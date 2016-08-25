// CS 218 - Provided C++ program
//	This programs calls assembly language routines.

//  NOTE: To compile this program, and produce an object file
//	must use the "g++" compiler with the "-c" option.
//	Thus, the command "g++ -c main.c" will produce
//	an object file named "main.o" for linking.

//  Must ensure g++ compiler is installed:
//	sudo apt-get update
//	sudo apt-get upgrade
//	sudo apt-get install g++

// ***************************************************************************

#include <cstdlib>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <iomanip>

using namespace std;

// ***************************************************************
//  Prototypes for external functions.
//	The "C" specifies to use the standard C/C++ style
//	calling convention.

extern "C" int getFiles(int, char **, FILE **, FILE **);
extern "C" int getBlock(FILE *, int *, int);
extern "C" int putBlock(FILE *, int *, int);
extern "C" int editBlock(int *, int, int *);

// ***************************************************************
//  Begin a basic C++ program (does not use objects).

int main(int argc, char* argv[])
{

// --------------------------------------------------------------------
//  Declare variables
//	Note, by default, C++ integers are doublewords (32-bits).

	FILE	*readFile, *writeFile;

	static	const	int	BLOCKSIZE=500;
	int	requesteBlockSize=BLOCKSIZE;
	int	actualBlockSize=BLOCKSIZE;
	int	newBlockSize;
	int	block[BLOCKSIZE];
	int	newBlock[BLOCKSIZE];

// --------------------------------------------------------------------
//  Main processing loop...

	if (getFiles(argc, argv, &readFile, &writeFile)) {

		while (actualBlockSize > 0) {

			actualBlockSize = getBlock(readFile, block,
						requesteBlockSize);

			if (actualBlockSize > 0) {
				newBlockSize = editBlock(block,
						actualBlockSize, newBlock);
				putBlock(writeFile, newBlock, newBlockSize);
			}
		}
	}

// --------------------------------------------------------------------
//  All done...

	return 0;
}

