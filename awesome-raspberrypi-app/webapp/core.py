from flask.ext.sqlalchemy import SQLAlchemy

from utils import create_app

app = create_app()
db = SQLAlchemy(app)
