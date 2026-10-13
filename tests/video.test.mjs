import {test} from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';
const html=fs.readFileSync(new URL('../3d-night/index.html',import.meta.url),'utf8');
const code=[...html.matchAll(/<script[^>]*>([\s\S]*?)<\/script>/gi)].at(-1)[1];
function setup({blocked=false,reduced=false}={}){
  const events={},videoEvents={},windowEvents={};let attempts=0,loads=0;
  const video={paused:true,style:{},dataset:{fallbackSrc:'fallback.mp4'},play(){attempts++;if(blocked)return Promise.reject(new Error('Autoplay blocked'));this.paused=false;return Promise.resolve();},load(){loads++;},pause(){this.paused=true;},addEventListener(name,fn){videoEvents[name]=fn;}};
  const document={hidden:false,querySelector:()=>video,addEventListener(name,fn){events[name]=fn;}};
  vm.runInNewContext(code,{document,window:{addEventListener(name,fn){windowEvents[name]=fn;}},matchMedia:()=>({matches:reduced})});
  return {video,document,events,videoEvents,windowEvents,attempts:()=>attempts,loads:()=>loads,unblock:()=>{blocked=false;}};
}
test('native video sources start loading before JavaScript and use portrait media',()=>{assert.match(html,/<video[^>]*autoplay[^>]*muted[^>]*playsinline[^>]*preload="auto"/);assert.match(html,/<source src="[^"]*hero_portrait.mp4"[^>]*media="\(max-aspect-ratio: 1\/1\)"/);assert.doesNotMatch(html,/<video[^>]*\scontrols(?:\s|>)/);});
test('startup explicitly enables muted inline playback',()=>{const s=setup();assert.equal(s.video.muted,true);assert.equal(s.video.defaultMuted,true);assert.equal(s.video.playsInline,true);assert.equal(s.video.paused,false);});
test('a blocked early gesture does not consume later playback retries',async()=>{const s=setup({blocked:true});s.events.touchstart();await new Promise(setImmediate);s.unblock();s.events.touchend();assert.equal(s.video.paused,false);assert.equal(s.attempts(),3);});
test('media readiness retries playback after an initial rejection',async()=>{const s=setup({blocked:true});await new Promise(setImmediate);s.unblock();s.videoEvents.canplay();assert.equal(s.video.paused,false);});
test('hidden pages pause and restored pages resume',()=>{const s=setup();s.document.hidden=true;s.events.visibilitychange();assert.equal(s.video.paused,true);s.document.hidden=false;s.windowEvents.pageshow();assert.equal(s.video.paused,false);});
test('reduced motion does not silently disable the requested background video',()=>{assert.equal(setup({reduced:true}).video.paused,false);});
test('decoder errors attempt a compatible fallback once without hiding the video',()=>{const s=setup();s.videoEvents.error();s.videoEvents.error();assert.equal(s.video.src,'fallback.mp4');assert.equal(s.loads(),1);assert.notEqual(s.video.style.display,'none');});
