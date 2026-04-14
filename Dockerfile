# FROM python:3.12-slim

# # Muhit o'zgaruvchilari
# ENV PYTHONDONTWRITEBYTECODE=1
# ENV PYTHONUNBUFFERED=1
# ENV TZ="Asia/Tashkent"
# WORKDIR /app

# # Tizim paketlari
# RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

# # Kutubxonalar
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt
# RUN pip install gunicorn

# # Loyihani ko'chirish
# COPY . .

# # Static fayllarni yig'ish
# RUN python manage.py collectstatic --noinput

# # Gunicorn orqali ishga tushirish
# CMD python manage.py makemigrations && python manage.py migrate --noinput && gunicorn project.wsgi:application --bind 0.0.0.0:8000






FROM python:3.12-slim

# Muhit o'zgaruvchilari
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV TZ="Asia/Tashkent"
# Railway portni avtomatik beradi, lekin standart 8000 ni saqlaymiz
ENV PORT=8000 

WORKDIR /app

# Tizim paketlari (Postgres uchun kerakli kutubxonalar)
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Kutubxonalarni o'rnatish (Keshdan foydalanish uchun alohida COPY qilinadi)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn

# Loyihani ko'chirish
COPY . .

# Static fayllarni yig'ish (Build vaqtida bajariladi)
RUN python manage.py collectstatic --noinput

# Gunicorn orqali ishga tushirish (JSON formatida tavsiya etiladi)
# Migratsiyalar va serverni ishga tushirishni bitta qatorga jamlaymiz
CMD sh -c "python manage.py migrate --noinput && gunicorn project.wsgi:application --bind 0.0.0.0:$PORT"
