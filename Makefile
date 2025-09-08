# Makefile - Commands for Inception project

# تشغيل جميع الخدمات
up:
	docker compose -f srcs/docker-compose.yml up --build -d

# إيقاف جميع الخدمات
down:
	docker compose -f srcs/docker-compose.yml down

# بناء جميع الخدمات بدون تشغيلها
build:
	docker compose -f srcs/docker-compose.yml build

# عرض اللوغز للخدمات باستمرار
logs:
	docker compose -f srcs/docker-compose.yml logs -f

# تنظيف كل شيء: containers, volumes, images غير المستخدمة
clean:
	docker system prune -af --volumes

# إعادة تشغيل كاملة: clean + build + up
re:
	$(MAKE) clean
	$(MAKE) up
