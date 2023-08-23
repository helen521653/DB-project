import os
import pytest
import psycopg2
from pypsql import psycopg2_execute_sql
from __init__ import execute_sql_to_df
from __init__ import read_sql


@pytest.fixture()
def select_script():
    path = os.getenv("PYTHON_PATH")
    return read_sql(path)


@pytest.fixture()
def select_df(select_script, sqlalchemy_conn):
    return execute_sql_to_df(
        conn=sqlalchemy_conn,
        sql=select_script
    )


#проверили, что в первом селекте из файла db_WF.sql 80 строк
def test_query_returns_correct_number_of_rows():
    query_result = psycopg2_execute_sql("SELECT COUNT(*) FROM (SELECT cd.group_user.user_id, cd.group_event.event_id FROM cd.group INNER JOIN cd.group_user ON cd.group_user.group_id = cd.group.group_id INNER JOIN cd.group_event ON cd.group_event.group_id = cd.group.group_id) f")
    for i  in query_result:
        print(i)
    assert query_result[0][0] == 80

#проверили, что в первом селекте из файла db_WF.sql в каждой группе не более 2 пользователей
def test_query_returns_column_value_within_interval():
    query_result = psycopg2_execute_sql("SELECT user_in_group FROM (SELECT DISTINCT cd.group.group_nm, count(cd.group_user.user_id) OVER (PARTITION BY cd.group.group_nm) AS user_in_group FROM cd.group_user LEFT JOIN cd.group ON cd.group.group_id = cd.group_user.group_id) f")
    for row in query_result:
        assert row[0] in range(0, 3)




if __name__ == '__main__':
    pytest.main()