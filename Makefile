.PHONY: install run test lint docker-build docker-run

install:
	pip install -r requirements.txt

run:
	python app.py

test:
	pytest -q

lint:
	flake8 .

docker-build:
	docker build -t flask-cicd-internship:latest .

docker-run:
	docker run --rm -p 5000:5000 flask-cicd-internship:latest
