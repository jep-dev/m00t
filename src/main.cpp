#include <iostream>

int main(int argc, const char *argv[]) {
	int index = 0;
	while(*argv) {
		std::cout << "Argv[" << index << "] = " << *argv << std::endl;
		index++;
		argv++;
	}
	return 0;
}
