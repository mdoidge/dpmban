# dpmban
Prototype BASH script that makes use of fetch-ban output to add banned DNs to the DOME userlist via simple dmlite-shell commands.

During testing fetch-ban should be configured with a minimal delay value in fetch-ban.conf.

Notes on logic:
-Exit if fetch-ban fails - better if users just stay banned.
-Check to see if a user that was in the previous ban list isn't on the new one, and unban if this is the case.
-if on the ban list but not an existing user, create the user (otherwise the userban command fails)
-only run the userban list if the user isn't currently banned (otherwise weird things start to happen).

-the reason for all the backslashe insertion into the DN strings is to allow spaces in DNs (which most DNs have).
