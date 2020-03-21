from setuptools import setup, find_packages


setup(name="working_with_github",
      entry_points="""
          [console_scripts]
          setup_oss=working_with_github.main:setup_oss
          checkout_pr=working_with_github.main:checkout_pr
          update_pr=working_with_github.main:update_pr
    """,
      packages=find_packages(),
)
