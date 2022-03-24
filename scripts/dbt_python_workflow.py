from fal import FalDbt
import os

cwd = os.getcwd()

faldbt = FalDbt(profiles_dir=cwd, project_dir=cwd)

print(faldbt.list_sources())

dim_customers_df = faldbt.ref('dim_customers')

print(dim_customers_df.tail())