#include <cstdio>
#include <iostream>
using namespace std;
long long cnt = 0;
int main()
{
	freopen("test7.data", "r", stdin);
	freopen("ttest.data", "w", stdout);
	char inst[8];
	char c;
	while(c = getchar())
	{
		if((c<='9'&&c>='0') || (c<='f'&& c>='a'))
		{
			cnt++;
			putchar(c);
			if(cnt%2 == 0) 
				putchar('\n');
		}
		else if(c != ' ' && c != '\n')
			break;
	}
	return 0;
} 
