#!/usr/bin/env python3
"""
pythonedaartifactapplicationgittagging/application.py

This file can be used to run PythonEDA applications with automatic git tagging.

Copyright (C) 2023-today rydnr's pythoneda-artifact-application/base

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""
from pythonedaapplication.pythoneda import PythonEDA

import asyncio

class GitTaggingApplication(PythonEDA):
    """
    Runs a PythonEDA application with support for Git tagging.

    Class name: GitTaggingApplication

    Responsibilities:
        - Runs a PythonEDA application with support for Git tagging.

    Collaborators:
        - Command-line handlers from pythoneda-artifact-infrastructure/git-tagging
    """
    def __init__(self):
        """
        Creates a new GitTaggingApplication instance.
        """
        super().__init__(__file__)

if __name__ == "__main__":

    asyncio.run(GitTaggingApplication.main())
