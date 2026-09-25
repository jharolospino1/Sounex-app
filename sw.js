const C="sounex-v5";
const A=["./","./index.html","./manifest.webmanifest","./icons/icon-192.png","./icons/icon-512.png","./icons/maskable-512.png","./icons/apple-touch-icon.png"];
self.addEventListener("install",e=>{e.waitUntil(caches.open(C).then(c=>c.addAll(A)).then(()=>self.skipWaiting()))});
self.addEventListener("activate",e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(n=>n!==C).map(n=>caches.delete(n)))).then(()=>self.clients.claim()))});
self.addEventListener("fetch",e=>{const r=e.request;if(r.method!=="GET"||new URL(r.url).origin!==location.origin||/\/(config\.js|admin\.html)$/.test(new URL(r.url).pathname))return;
e.respondWith(caches.match(r).then(m=>m||fetch(r).then(n=>{const cp=n.clone();caches.open(C).then(c=>c.put(r,cp));return n}).catch(()=>r.mode==="navigate"?caches.match("./index.html"):undefined)))});
