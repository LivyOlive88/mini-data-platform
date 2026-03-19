FROM apache/airflow:2.9.1-python3.11

USER root

# FIX 3: The original apt-get install had no packages listed after
# --no-install-recommends, which causes a parse error. Either list actual
# packages here, or just clean up the apt cache as shown below.
# Add any required system packages on the line below (e.g. libpq-dev).
RUN apt-get update && apt-get clean && rm -rf /var/lib/apt/lists/*

USER airflow

# Copy and install Python requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy source code into the image so it's available on PYTHONPATH
COPY src/ /opt/airflow/src/
COPY airflow/dags/ /opt/airflow/dags/
COPY scripts/ /opt/airflow/scripts/