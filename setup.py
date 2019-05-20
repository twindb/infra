"""Setup module"""
from textwrap import dedent

from setuptools import setup, find_packages

def parse_requirements(req_file):
    """
    Parse file with requirements and return a dictionary
    consumable by setuptools.

    :param req_file: path to requirements file.
    :type req_file: str
    :return: Dictionary with requirements.
    :rtype: dict
    """
    with open(req_file) as fdescr:
        reqs = fdescr.read().strip().split('\n')
    return [x for x in reqs if x and not x.strip().startswith('#')]

REQUIREMENTS = parse_requirements('requirements/requirements.txt')
TEST_REQUIREMENTS = parse_requirements('requirements/requirements_test.txt')
SETUP_REQUIREMENTS = parse_requirements('requirements/requirements_setup.txt')

if __name__ == '__main__':
    setup(
        name='infra-support',
        version='0.1.0',
        description="TwinDB Support Package for the infra repo",
        long_description=dedent(
            """
            The TwinDB Support Package is a toolkit of auxiliary commands
            needed for the repo maintenance.
            """
        ),
        author="TwinDB Development Team",
        author_email='dev@twindb.com',
        url='https://github.com/twindb/infra',
        packages=find_packages(exclude=('tests*',)),
        package_dir={
            'support': 'support'
        },
        entry_points={
            'console_scripts': [
                'install-terraform=support.install_terraform:install_terraform',
                'ci-runner=support.ci_runner:ci_runner'
            ]
        },
        include_package_data=True,
        install_requires=REQUIREMENTS,
        license="Apache Software License 2.0",
        zip_safe=False,
        classifiers=[
            'Development Status :: 5 - Production/Stable',
            'Environment :: Console',
            'Intended Audience :: Developers',
            'License :: OSI Approved :: Apache Software License',
            'Natural Language :: English',
            'Operating System :: POSIX :: Linux',
            'Programming Language :: Python :: 3',
            'Programming Language :: Python :: 3.7'
        ],
        setup_requires=SETUP_REQUIREMENTS,
        test_suite='tests',
        tests_require=TEST_REQUIREMENTS,
    )
