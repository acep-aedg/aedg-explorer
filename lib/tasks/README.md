# ETL Pipeline 

## Overall Stragety and Organization
Generally speaking, we would like to build a pipeline that takes care it's users and itself. We don't want to manually run scripts every day at midnight, nor do we want breakage to cascade downstream. 

### `api/`
Tools:
- automation/orchestration (shell/cron? dagster?)
- python for actual api scripts
- sha256sum for validity
- storage for stashing raw data (in repo for now with git lfs, switch later)

Goals:
This step kicks off the pipeline, running scripts to pull data down from various APIs and stash it unchanged in a storage location. Output is CSV, GeoJSON, etc. Git LFS intercepts the data and stashes wherever it stashes data.


### `preprocess/`
Tools:
- automation/orchestration (shell/cron? dagster?)
- python (ibis?) for actual preprocessing scripts
- python (pytest?) for validation and testing
- storage for stashing preprocessed data (in repo for now, switch later)

Goals:
Ideally, this step happens with as light of a touch as possible. Perform as little cleaning here as you can, leaving column names intact (minus whitespace) etc. If something is horribly wrong and will break downstream processes, then fix it and add it to the changelog. Otherwise, leave it alone. Outputs are again saved to disk (repo for now). 


### `load/`
Tools:
- automation/orchestration (shell/cron? dagster?)
- SQL scripts for loading into db
- postgres

Goals:
Get the data into the database! No change to the data happens in this step, just basic SQL commands run via shell scripts, automated by cron. The outputted database is the beginning of the `dev` database. 

 

### `transform/`
Tools:
- dbt for automation and orchestration
- SQL for scripting
- postgres

Goals:
This step is the rice and beans of the pipeline. Minimally processed data is present in the database, now is the time to really clean and transform it. Scripts are written in SQL and run via DBT. Outputs are written back to the `dev` database under a different schema (ex: transformed), maintining the raw data (ex: source). 


### Next Steps
Tools:
- Ruby/Rails/Rake for scripting and automation

Goals:
Once the data is in a final state, the database is dumped and replicated as `prod`. This new database is unchanging, forming the backend of the Rails app. No transformations happen here, no renames, no new tables. Additionally, permissions are defined with anticipation of being public-facing. 


