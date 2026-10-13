import {test} from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';
const html=fs.readFileSync(new URL('../3d-night/index.html',import.meta.url),'utf8');
const code=[...html.matchAll(/<script[^>]*>([\s\S]*?)<\/script>/gi)].at(-1)[1];
function setup({mobile=true,reduced=false,blocked=false}={}){
  const events={},videoEvents={};let attempts=0;
  const video={paused:true,style:{},dataset:{mobileSrc:'mobile.mp4',desktopSrc:'desktop.mp4'},removeAttribute(name){this[name]=false;},play(){attempts++;if(blocked)return Promise.reject(new Error('Autoplay blocked'));this.paused=false;return Promise.resolve();},pause(){this.paused=true;},addEventListener(name,fn){videoEvents[name]=fn;}};
  const document={hidden:false,querySelector:()=>video,addEventListener(name,fn){events[name]=fn;}};
  vm.runInNewContext(code,{document,matchMedia:q=>({matches:q.includes('reduced-motion')?reduced:mobile})});
  return {video,document,events,videoEvents,attempts:()=>attempts,unblock:()=>{blocked=false;}};
}
test('mobile autoplay selects mobile source and enables muted inline playback',()=>{const s=setup();assert.equal(s.video.src,'mobile.mp4');assert.equal(s.video.muted,true);assert.equal(s.video.defaultMuted,true);assert.equal(s.video.playsInline,true);assert.equal(s.video.paused,false);});
test('desktop selects desktop source',()=>assert.equal(setup({mobile:false}).video.src,'desktop.mp4'));
test('blocked autoplay retries on the first touch without adding controls',async()=>{const s=setup({blocked:true});await new Promise(setImmediate);assert.equal(s.video.paused,true);s.unblock();s.events.touchstart();assert.equal(s.video.paused,false);assert.equal(s.attempts(),2);assert.doesNotMatch(html,/video-toggle|<video[^>]*\scontrols(?:\s|>)/);});
test('hidden pages pause and visible pages resume',()=>{const s=setup();s.document.hidden=true;s.events.visibilitychange();assert.equal(s.video.paused,true);s.document.hidden=false;s.events.visibilitychange();assert.equal(s.video.paused,false);});
test('reduced motion keeps the poster without downloading a video',()=>{const s=setup({reduced:true});assert.equal(s.video.src,undefined);assert.equal(s.attempts(),0);assert.equal(s.video.autoplay,false);});
test('a media error leaves the poster visible',()=>{const s=setup();s.videoEvents.error();assert.equal(s.video.style.display,'none');assert.match(html,/background:url\(\.\.\/images\/deltaandbay_hero_poster.jpg\)/);});
