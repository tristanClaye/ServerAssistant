web: gunicorn -w 4 -b 0.0.0.0:5000 textConverter:app
web: gunicorn --worker-tmp-dir /dev/shm --workers=2 -b 0.0.0.0:$PORT textConverter:create_app