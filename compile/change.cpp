#include <cstdio>
#include <iostream>
using namespace std;
long long cnt = 0;
int main(int argc, char* argv[])
{
	freopen("testl.data", "r", stdin);
	freopen("test_l.data", "w", stdout);
	char inst[8];
	char c;
	while(c = getchar())
	{
		if((c<='9'&&c>='0') || (c<='f'&& c>='a'))
		{
			cnt++;
			putchar(c);
			if(cnt%2 == 0)
				putchar(' ');
			if(cnt%8 == 0) 
				putchar('\n');
		}
		else if(c != ' ' && c != '\n')
			break;
	}
	return 0;
} 
