//[]-----------------------------------------------------------------[]
//|   ZCLKERNL.H -- kernel header file				      |
//[]-----------------------------------------------------------------[]
//
// $Copyright: 2005$
// $Revision: 1.1.1.1 $
//
#if !defined(ZCLKERNL_H)
#define ZCLKERNL_H

typedef unsigned long dword;
typedef dword index;
typedef dword count;
typedef int cstat;

class Memblock
{
private:
  void *Ptr;
  int Size;
public:
  // Default Ctr
  __fastcall Memblock(dword size);
  __fastcall Memblock(const Memblock &Mem);
  __fastcall ~Memblock();

  void __fastcall Resize(dword size);
  void __fastcall Copy(const Memblock &Mem);
  void __fastcall Copy(const Memblock &Mem, count Count);
  void __fastcall Assign(const Memblock &Mem);
  void __fastcall Swap(const Memblock &Mem);
  void __fastcall Set(char Sym);
  void __fastcall Set(char Sym, index Index, count Count);
  index __fastcall Char(char Sym);
  index __fastcall Char(char Sym, index Index);
  cstat __fastcall Compare(const Memblock &Mem);
  index __fastcall Seek(const Memblock &Mem);
  index __fastcall Seek(const Memblock &Mem, index Index, count Count);
  void __fastcall operator >>(const Memblock &Mem);
  void __fastcall operator <<(const Memblock &Mem);
  bool __fastcall operator ==(const Memblock &Mem);
  bool __fastcall operator !=(const Memblock &Mem);
  bool __fastcall operator <=(const Memblock &Mem);
  bool __fastcall operator >=(const Memblock &Mem);
  bool __fastcall operator <(const Memblock &Mem);
  bool __fastcall operator >(const Memblock &Mem);
  Memblock & __fastcall operator =(const Memblock &Mem);

};

#endif

