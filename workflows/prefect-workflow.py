import prefect
from prefect import task, Flow
from prefect.run_configs import KubernetesRun

@task
def say_hello():
    logger = prefect.context.get("logger")
    logger.info("Hello, Logger!")
    print("Hello Print!")

with Flow("bio2kg-etl") as flow:
    say_hello()


flow.run_config = KubernetesRun(
    env={"SOME_VAR": "VALUE"},
    # image="my-custom-image"
)

# state = flow.run()
# assert state.is_successful()

flow.register(project_name="bio2kg")
