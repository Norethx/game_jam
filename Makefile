pull:
	@git pull --no-rebase --no-edit -X theirs origin past

past:
	@git push origin past

future:
	@git push origin past
