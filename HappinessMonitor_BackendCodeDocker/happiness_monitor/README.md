docker compose up --build
docker compose run web python happiness/manage.py migrate
docker compose run web python happiness/manage.py createsuperuser



//One time only: docker compose run web python happiness/manage.py makemigrations core