codegen: 
	dart run build_runner build --delete-conflicting-outputs

codeformat:
	flutter analyze .
