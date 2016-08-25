// CS 218 - Provided C++ program
//	This programs calls assembly language routines.

//  NOTE: To compile this program, and produce an object file
//	must use the "g++" compiler with the "-c" option.
//	Thus, the command "g++ -c main.c" will produce
//	an object file named "main.o" for linking.

//  Must ensure g++ compiler is installed:
//	sudo apt-get install g++

// ***************************************************************************

#include <cstdlib>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <iomanip>

using namespace std;

#define MAXLENGTH 1000
#define MINLENGTH 3

#define SUCCESS 0
#define NOSUCCESS 1
#define OUTOFRANGEMIN 2
#define OUTOFRANGEMAX 3
#define INPUTOVERFLOW 4
#define ENDOFINPUT 5


// ***************************************************************
//  Prototypes for external functions.
//	The "C" specifies to use the C/C++ style calling convention.

extern "C" int readBinaryNum(int *);
extern "C" void cocktailSort(int[], int);
extern "C" void cubeAreas(int[], int, int[]);
extern "C" void cubeStats(int[], int, int *, int *, int *, int *, int *);
extern "C" int iMedian(int[], int);
extern "C" long long mStatistic(int[], int);


// ***************************************************************
//  Begin a basic C++ program.
//	Note, does not use any objects.

int main()
{

// --------------------------------------------------------------------
//  Declare variables and display simple header
//  By default, C++ integers are doublewords (32-bits).

	string	bars;
	bars.append(50,'-');

	int		status, newNumber;
	int		list[MAXLENGTH];
	int		cAreas[MAXLENGTH];
	int		len = 0;
	int		lstMin, lstMax, lstSum, lstAve;
	int		lstMed, lstFourSum;
	long long	lstMstat;
	bool		endOfNumbers = false;

	cout << bars << endl;
	cout << "CS 218 - Assignment #9" << endl << endl;

// --------------------------------------------------------------------
//  Loops to read numbers from user.

	while (!endOfNumbers && len<MAXLENGTH) {

		printf ("Enter Value (binary): " );
		fflush(stdout);
		status = readBinaryNum(&newNumber);

		switch (status) {
			case SUCCESS:
				list[len] = newNumber;
				len++;
				break;
			case NOSUCCESS:
				cout << "Error, invalid number. ";
				cout << "Please re-enter." << endl;
				break;
			case OUTOFRANGEMIN:
				cout << "Error, number below minimum value. ";
				cout << "Please re-enter." << endl;
				break;
			case OUTOFRANGEMAX:
				cout << "Error, number above maximum value. ";
				cout << "Please re-enter." << endl;
				break;
			case INPUTOVERFLOW:
				cout << "Error, user input exceeded " <<
					"length, input ignored. ";
				cout << "Please re-enter." << endl;
				break;
			case ENDOFINPUT:
				endOfNumbers = true;
				break;
			default:
				cout << "Error, invalid return status. ";
				cout << "Program terminated" << endl;
				exit(EXIT_FAILURE);
				break;
		}
		if (len > MAXLENGTH)
			break;
	}

// --------------------------------------------------------------------
//  Ensure some numbers were read and, if so, display results.

	if (len < MINLENGTH) {
		cout << "Error, not enough numbers entered." << endl;
		cout << "Program terminated." << endl;
	} else {
		cout << bars << endl;
		cout << endl << "Program Results" << endl << endl;

		cubeAreas(list, len, cAreas);
		cocktailSort(cAreas, len);
		cubeStats(cAreas, len, &lstMin, &lstMax, &lstSum,
				&lstAve, &lstFourSum);
		lstMed = iMedian(cAreas, len);
		lstMstat = mStatistic(cAreas, len);

		cout << "Sorted Cube Areas List: " << endl;
		for (int i = 0; i < len; i++) {
			cout << setw(6) << cAreas[i] << "  ";
			if ( (i%5)==4 || i==(len-1) ) cout << endl;
		}
		cout << endl;
		cout << "  Count       =  " << setw(12) << len << endl;
		cout << "  Minimum     =  " << setw(12) << lstMin << endl;
		cout << "  Maximum     =  " << setw(12) << lstMax << endl;
		cout << "  Median      =  " << setw(12) << lstMed << endl;
		cout << "  Sum         =  " << setw(12) << lstSum << endl;
		cout << "  Average     =  " << setw(12) << lstAve << endl;
		cout << "  Four Sum    =  " << setw(12) << lstFourSum << endl;
		cout << "  m-statistic =  " << setw(12) << lstMstat << endl;
		cout << endl;
	}

// --------------------------------------------------------------------
//  All done...

	return 0;

}

