# README - Task Library

This README is for the repository of code snippet task library items for custom actions in Calm.

# Table of Contents

<!-- TOC -->

- [README - Task Library](#readme---task-library)
- [Table of Contents](#table-of-contents)
- [Usage](#usage)
  - [Indexes](#indexes)
- [Development](#development)
  - [Repo Best Practices](#repo-best-practices)
    - [A Word About Storage](#a-word-about-storage)
    - [**Branching, Committing, Pulling**](#branching-committing-pulling)
      - [**Branch Naming**](#branch-naming)
- [Contribute](#contribute)
  - [Adding new features or fixing bugs](#adding-new-features-or-fixing-bugs)
- [Footer](#footer)

<!-- /TOC -->
# Usage

[(Back to top)](#table-of-contents)

This repo contains a library of code snippets that can be used as custom actions in Nutanix Calm.

***DO NOT DROP RANDOM FILES AT THE TOP LEVEL DIRECTORY OR YOUR PR WILL BE REJECTED***

## Indexes

Each section of the library should have an accompanying *`index.md`* file. These indexes are meant to simplify discoverability and engender code hygiene. [This is the top level index file.](./index.md)

If adding a code snippet to an existing category subdirectory, please update the category index. If adding code snippets to a new category, please add the category to the index as well.

# Development

[(Back to top)](#table-of-contents)

## Repo Best Practices

### A Word About Storage

We do not have unlimited storage in our GitHub subscription therefore it is critical that no binaries, archives or large files be stored in your repositories. These repos are for scripts, source code, notes and documentation.

### **Branching, Committing, Pulling**

Branching is the mechanism that facilitates multiple teams and/or team members working on multiple features simultaneously. It is critical that a branching strategy be implemented and adhered to in order to provide an environment for parallel development that protects the master branch and provide a means in which code reviews are encouraged.

#### **Branch Naming**

To add features, crush bugs, edit documents, etc. create a branch from **main** using the following naming convention

> ```<username>-<feature>-<issue/Jira number>```

For example:

> ```broome-add_F5_API-44```

Once you've completed your update, edit, etc., create a pull request for review from **practice leads** to merge changes back to master.

For complete GitHub branching strategy best practices, please refer to [this Confluence page](https://confluence.eng.nutanix.com:8443/display/NPS/Nutanix+Services+Customer+GitHub+Repository+Processes#NutanixServicesCustomerGitHubRepositoryProcesses-BranchingStrategy).

<img src="https://www.dropbox.com/s/87rkif5r6zb1zvx/NoCommitToMaster.jpg?raw=1" height="165" />

---

# Contribute

[(Back to top)](#table-of-contents)

## Adding new features or fixing bugs

# Footer

[(Back to top)](#table-of-contents)

<img src="https://media.giphy.com/media/SS8CV2rQdlYNLtBCiF/giphy.gif" width="50" height="50">    <img src="https://media.giphy.com/media/du3J3cXyzhj75IOgvA/giphy.gif" width="50" height="50"> 