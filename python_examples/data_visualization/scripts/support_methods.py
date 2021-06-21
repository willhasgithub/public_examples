from json import loads
from pathlib import Path
from sqlalchemy import create_engine


def get_default_connection_parameters() -> dict:
    db_connection_file = get_docs_file("db_connection_data.json")
    with open(db_connection_file, "r") as connection_file:
        connection_dict = loads(connection_file.read())
    return connection_dict


def create_db_connection(**kwargs) -> create_engine:
    """
    If no arguments are passed the default connection is created as defined by docs/db_connection_data.json
    To override any parameters in that connection file pass the variables as such:
        dialect_and_driver=str, user=str, password=str, host=str, port=str, db_name=str

    Returns an engine type from sqlalchemy import create_engine.

    :param kwargs: dialect_and_driver=str, user=str, password=str, host=str, port=str, db_name=str
    :return: engine -> sqlalchemy engine type
    """
    default_connection_dict = get_default_connection_parameters()

    connection_dict = {}
    for key, val in default_connection_dict.items():
        if key in kwargs.keys():
            connection_dict[key] = kwargs[key]
        else:
            connection_dict[key] = val

    connection_keys = ["dialect_and_driver", "user", "password", "host", "port", "db_name"]
    connection_parameters = [connection_dict[con_key] for con_key in connection_keys]
    connection_string = "{0}://{1}:{2}@{3}:{4}/{5}".format(*connection_parameters)

    engine = create_engine(connection_string)
    return engine


def get_project_root() -> Path:
    return Path(__file__).parent.parent


def get_docs_directory() -> Path:
    return get_project_root() / "docs"


def get_scripts_directory() -> Path:
    return get_project_root() / "scripts"


def get_docs_file(file_name) -> Path:
    return get_docs_directory() / file_name


def get_script_file(file_name) -> Path:
    return get_scripts_directory() / file_name


if __name__ == '__main__':
    pass
