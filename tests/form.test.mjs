import {test} from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';

const html=fs.readFileSync(new URL('../apply/index.html',import.meta.url),'utf8');
const source=[...html.matchAll(/<script[^>]*>([\s\S]*?)<\/script>/gi)][0][1];
function setup(response=()=>Promise.resolve({ok:true,status:201})) {
  const classes=new Set(), errors=new Set();
  const button={disabled:false,textContent:'Submit application'};
  const error={classList:{add:k=>errors.add(k),remove:k=>errors.delete(k)}};
  const first={textContent:''};
  const values={name:'QA Tester',email:'qa@example.com',company:'QA',based:'Test city',linkedin:'linkedin.com/in/qa-tester',x:'@qa_tester',website:'https://example.com?ref=test',role:'Other',area:'Other',building:'Testing the form safely.',why:'Testing error recovery safely.',dates:'No',heard:''};
  const elements=Object.fromEntries(Object.entries(values).map(([name,value])=>{
    const message={dataset:{},textContent:'Original field error'};
    const field={classList:{toggle(){},contains(){return false;}},querySelector:()=>message};
    const input=html.match(new RegExp('<(?:input|select|textarea)\\b[^>]*\\bname="'+name+'"[^>]*>'))[0];
    return [name,{name,value,required:/\srequired(?:\s|>)/.test(input),minLength:['building','why'].includes(name)?10:-1,checkValidity:()=>true,closest:()=>field,addEventListener(){},focus(){}}];
  }));
  let submit,requests=0,lastPayload;
  const form={elements,querySelectorAll:()=>Object.values(elements),addEventListener:(event,fn)=>{if(event==='submit')submit=fn;},querySelector:selector=>selector==='button'?button:error};
  const sandbox={URL,document:{getElementById:id=>id==='apply'?form:first,body:{classList:{add:k=>classes.add(k)}}},scrollTo(){},fetch:(url,options)=>{requests++;lastPayload=JSON.parse(options.body);return response();}};
  vm.createContext(sandbox);vm.runInContext(source,sandbox);
  return {sandbox,elements,button,error,classes,errors,first,submit:()=>submit({preventDefault(){}}),requests:()=>requests,payload:()=>lastPayload};
}
test('website query and fragment are normalized into database-compatible URLs',()=>{
  const {sandbox:s}=setup();
  assert.equal(s.normWebsite('https://example.com?ref=test'),'https://example.com/?ref=test');
  assert.equal(s.normWebsite('example.com#about'),'https://example.com/#about');
  assert.equal(s.normWebsite('example.com'),'https://example.com/');
});
test('website rejects unsafe schemes, credentials, whitespace, malformed ports and excessive length',()=>{
  const {sandbox:s}=setup();
  for(const input of ['javascript:alert(1)','https://user:password@example.com','https://example.com/has space','https://example.com:99999','https://example.com/'+ 'a'.repeat(300)]) assert.equal(s.normWebsite(input),null,input);
});
test('required and optional lengths match database boundaries with field-specific errors',()=>{
  const {sandbox:s,elements}=setup();
  for(const [name,limit] of Object.entries({name:200,email:320,company:200,based:200,building:4000,why:4000,heard:500})) {
    const field=elements[name]; assert.equal(field.maxLength,limit);
    field.value='a'.repeat(limit);assert.equal(s.check(field),true,name+' boundary');
    field.value+='a';assert.equal(s.check(field),false,name+' overflow');
    assert.match(field.closest().querySelector().textContent,/characters or fewer/);
  }
});
test('trimmed blank and short answers stay invalid',()=>{
  const {sandbox:s,elements}=setup();
  elements.name.value='   ';assert.equal(s.check(elements.name),false);
  elements.building.value='       short       ';assert.equal(s.check(elements.building),false);
});
test('invalid fields prevent network submission',()=>{
  const s=setup();s.elements.heard.value='a'.repeat(501);s.submit();assert.equal(s.requests(),0);
});
test('successful response displays confirmation and sends normalized payload',async()=>{
  const s=setup();s.submit();assert.equal(s.button.disabled,true);
  await new Promise(setImmediate);
  assert.equal(s.requests(),1);assert.equal(s.classes.has('sent'),true);assert.equal(s.first.textContent,'QA');
  assert.equal(s.payload().website,'https://example.com/?ref=test');
  assert.equal(s.payload().linkedin,'https://www.linkedin.com/in/qa-tester');
  assert.equal(s.payload().x,'https://x.com/qa_tester');
});
test('HTTP errors preserve answers, show error and allow retry',async()=>{
  const s=setup(()=>Promise.resolve({ok:false,status:503}));s.submit();await new Promise(setImmediate);
  assert.equal(s.classes.has('sent'),false);assert.equal(s.errors.has('show'),true);assert.equal(s.button.disabled,false);assert.equal(s.elements.name.value,'QA Tester');
});

test('blank or whitespace X profiles submit as null while LinkedIn remains required',async()=>{
  for(const value of ['', '   ']){
    const s=setup();s.elements.x.value=value;s.submit();await new Promise(setImmediate);
    assert.equal(s.requests(),1);assert.equal(s.payload().x,null);assert.equal(s.classes.has('sent'),true);
  }
  const s=setup();s.elements.linkedin.value='';s.elements.x.value='';s.submit();assert.equal(s.requests(),0);
});

test('an optional X profile still rejects malformed input',()=>{
  const s=setup();s.elements.x.value='not a profile';s.submit();assert.equal(s.requests(),0);
});
test('network errors recover the submit button without false success',async()=>{
  const s=setup(()=>Promise.reject(new Error('offline')));s.submit();await new Promise(setImmediate);
  assert.equal(s.classes.has('sent'),false);assert.equal(s.button.disabled,false);assert.equal(s.errors.has('show'),true);
});
