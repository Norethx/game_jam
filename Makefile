pull_main:
	@git pull --no-rebase --no-edit -X theirs origin main

pull_past:
	@git pull --no-rebase --no-edit -X theirs origin past

pull_future:
	@git pull --no-rebase --no-edit -X theirs origin future

main:
	@git push origin main

past:
	@git push origin past

future:
	@git push origin future


teste:
	echo teste

