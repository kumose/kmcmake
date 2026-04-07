# Usage Demo

Run the end-to-end demo from repo root:

```bash
bash example/run_usage_demo.sh
```

Optional custom generated project name:

```bash
bash example/run_usage_demo.sh my_demo_name
```

What this demo does:

- generate a project from `template/`
- configure/build/test generated project
- install generated project
- create and build an external consumer using `find_package(...)`
