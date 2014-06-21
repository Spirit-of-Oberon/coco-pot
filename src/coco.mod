(* Implementation restrictions
       3  too many nodes in graph (>1500)                         CRG.NewNode
       4  too many sets (ANY-symbols or SYNC symbols)     CRT.NewAnySet,
                                                                               CRT.ComputeSyncSet
       6  too many symbols (>300)                                   CRT.NewSym
       7  too many character classes (>50)                        CRT.NewClass
       9  too many conditions in generated code (>100)        CRX.NewCondSet

   Trace output (ddt settings: ${digit})
    0  Prints states of automaton
    1  Prints start symbols and followers of nonterminals (also option /s)
    2  Prints the internal graph
    3  Trace of start symbol set computation
    4  Trace of follow set computation
    5  suppresses FORWARD declarations in parser (for multipass compilers)
    6  Prints the symbol list
    7  Prints a cross reference list  (also option /x)
    8  Write statistics
==========================================================================*)
MODULE Coco;

IMPORT OS, Files, Texts, CRS, CRP, CRT;

CONST minErrDist = 8;

VAR w: Texts.Writer; lastErrPos: LONGINT;


PROCEDURE *Error (n: INTEGER; pos: LONGINT);

  PROCEDURE Msg (s: ARRAY OF CHAR);
  BEGIN Texts.WriteString(w, s)
  END Msg;

BEGIN
  INC(CRS.errors);
  IF pos < lastErrPos + minErrDist THEN lastErrPos := pos; RETURN END;
  lastErrPos := pos;
  Texts.WriteString(w, " pos "); Texts.WriteInt(w, pos, 6);
  Texts.WriteString(w, " error "); Texts.WriteInt(w, n, 3);
  Texts.WriteLn(w); Texts.Append(Files.StdOut, w.buf)
END Error;

PROCEDURE Options(VAR s: Texts.Scanner);
  VAR i: INTEGER;
BEGIN
  IF s.nextCh = "/" THEN Texts.Scan(s); Texts.Scan(s);
    IF s.class = Texts.Name THEN i := 0;
      WHILE s.s[i] # 0X DO
        IF CAP(s.s[i]) = "X" THEN CRT.ddt[7] := TRUE
        ELSIF CAP(s.s[i]) = "S" THEN CRT.ddt[1] := TRUE
        END;
        INC(i)
      END
    END
  END;
END Options;


PROCEDURE Compile*;
  VAR s: Texts.Scanner; t, src: Texts.Text;
    pos: LONGINT; i: INTEGER;
    name: ARRAY Files.MaxPathLength OF CHAR;
BEGIN OS.GetParFile(name);
  Texts.Open(t, name);
  Texts.OpenScanner(s, t, 0); Texts.Scan(s);
  src := NIL; pos := 0;
  IF s.class = Texts.Name THEN
    Texts.Open(src, s.s);
    Texts.WriteString(w, s.s); Texts.Append(Files.StdOut, w.buf)
  END;
  IF src # NIL THEN
    Texts.WriteLn(w);
    i := 0; WHILE i < 10 DO CRT.ddt[i] := FALSE; INC(i) END;
    Options(s);
    CRS.Reset(src, pos, Error); lastErrPos := -10;
    CRP.Parse
  ELSE Texts.WriteString(w, ": no source"); Texts.WriteLn(w)
  END
END Compile;

BEGIN Texts.OpenWriter(w);
  Texts.WriteString (w, "Coco/R - Compiler-Compiler V2.2"); Texts.WriteLn(w);
  Texts.Append(Files.StdOut, w.buf)
END Coco.
