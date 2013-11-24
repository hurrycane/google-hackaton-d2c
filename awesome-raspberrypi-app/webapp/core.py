from flask.ext.sqlalchemy import SQLAlchemy

from webapp.utils import create_app

app = create_app()
db = SQLAlchemy(app)
