#include "../src/zclkernl.h"
#include <stdio.h>


#include <windows.h>
#ifdef __BORLANDC__
  #pragma argsused
#endif
int APIENTRY WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow )
{
//  FastString a("123.3");
  char c = 'b';
  Memblock a(10), b(1000);
  a.Swap(b);
  index idx = a.Seek(b);
  idx = a.Seek(b, 1,10);
//  a <> b;
  b << a;
  int k = a.Char(c);
  a.Set(c);
  k = a.Char(c,1);
  a.Set(c,1,1);
  int j = a.Compare(b);
  bool bl = a == b;
  bl = a != b;
  bl = a >= b;
  bl = a <= b;
  bl = a > b;
  bl = a < b;
  a = b;
  char *p = getenv("PATH");
  printf("path=%s",p);
//  void *i = LoadLibrary("..\\..\\..\\..\\bin\\zclkernl.dll");
  void *i = LoadLibrary("zclkernl.dll");
  printf("loading=%i",(int)i);
  int l = GetLastError();
//  int i = a;
/*  char c = a;
  short s = a;
  float f = a;
  double d = a;
  long double extendedf = a;
  void *p = a;
  char *s1 = (char *)p;*/
  int l1 = l & (!!(int)i)-1;
  return l1;
}
