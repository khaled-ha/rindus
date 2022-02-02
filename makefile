.PHONY: clean venv create_super_user migration makemigrations set_env_var run_rindus

clean:
	rm -rf venv

venv:
	python -m venv venv && source venv/bin/activate
	pip install -r requirements.txt

create_super_user:
	docker-compose exec rindus ./manage.py createsuperuser

migration:
	docker-compose exec rindus ./manage.py migrate

makemigrations:
	docker-compose exec rindus ./manage.py makemigrations

set_env_var:
	cp rindus_test/env.tpl rindus_test/.env

run_rindus:
	docker-compose up -docker
