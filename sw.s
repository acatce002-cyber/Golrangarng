const CACHE_NAME = 'golrang-v2'; // ← نسخه رو بروز کن

const urlsToCache = [
  'index.html',
  'news.html',
  'admin.html',
  'style.css',
  'manifest.json'
];

// نصب - پاک کردن cache قدیمی و ساخت جدید
self.addEventListener('install', event => {
  console.log('✅ Installing SW v2...');
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll(urlsToCache).catch(err => {
        console.log('⚠️ Cache add failed for some files:', err);
      });
    }).then(() => self.skipWaiting()) // ← این خط مهمه
  );
});

// فعال‌سازی - پاک کردن همه cache های قدیمی
self.addEventListener('activate', event => {
  console.log('✅ Activating SW v2...');
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            console.log('🗑️ Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    }).then(() => self.clients.claim()) // ← این هم مهمه
  );
});

// Fetch - همیشه اول از شبکه، اگه نشد از cache
self.addEventListener('fetch', event => {
  event.respondWith(
    fetch(event.request)
      .then(response => {
        // یه کپی تازه توی cache ذخیره کن
        const responseClone = response.clone();
        caches.open(CACHE_NAME).then(cache => {
          cache.put(event.request, responseClone);
        });
        return response;
      })
      .catch(() => {
        // اگه آفلاین بودی، از cache بخون
        return caches.match(event.request);
      })
  );
});