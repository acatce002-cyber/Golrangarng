// نسخه رو حتماً عوض کن
const CACHE_NAME = 'golrang-v6-' + Date.now();

// لیست فایل‌هایی که باید cache بشن
const urlsToCache = [
  './',
  './index.html',
  './manifest.json'
];

// نصب
self.addEventListener('install', event => {
  console.log('✅ نصب SW جدید...');
  self.skipWaiting(); // ← این خط خیلی مهمه
});

// فعال‌سازی - همه cache قدیمی رو پاک کن
self.addEventListener('activate', event => {
  console.log('✅ فعال‌سازی SW جدید...');
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          console.log('🗑️ حذف cache:', cacheName);
          return caches.delete(cacheName); // ← همه رو پاک کن
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch - همیشه از شبکه بگیر
self.addEventListener('fetch', event => {
  event.respondWith(
    fetch(event.request)
      .then(response => {
        return response;
      })
      .catch(() => {
        return caches.match(event.request);
      })
  );
});