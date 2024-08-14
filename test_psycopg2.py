import psycopg2
import os

# Replace this with your actual DATABASE_URL from Heroku
#DATABASE_URL = os.getenv('DATABASE_URL', 'your-database-url-here')
DATABASE_URL = 'postgres://u162lg6qa5e4a1:p6ae5e17efc138d3e92903b40a6a3d5262c512a629255e88525c16b2df15000d0@c6al47t7hmv072.cluster-czrs8kj4isg7.us-east-1.rds.amazonaws.com:5432/d26oglqvhcc1bd'
try:
    # Connect to the database
    connection = psycopg2.connect(DATABASE_URL, sslmode='require')
    
    # Create a cursor object
    cursor = connection.cursor()
    
    # Execute a query
    cursor.execute("SELECT version();")
    
    # Fetch and print the result of the query
    db_version = cursor.fetchone()
    print("Connected to - {}\n".format(db_version))
    
    # Close the cursor and connection
    cursor.close()
    connection.close()

except (Exception, psycopg2.DatabaseError) as error:
    print("Error: {}".format(error))
