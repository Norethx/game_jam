pull_past:
	@git pull --no-rebase --no-edit -X theirs origin past

pull_future:
	@git pull --no-rebase --no-edit -X theirs origin future

past:
	@git push origin past

future:
	@git push origin past
