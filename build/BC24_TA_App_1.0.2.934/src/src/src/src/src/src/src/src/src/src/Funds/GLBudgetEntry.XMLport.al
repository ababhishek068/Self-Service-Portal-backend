XmlPort 50004 "G/L Budget Entry"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("G/L Budget Entry"; "G/L Budget Entry")
            {
                XmlName = 'glbudget';
                fieldelement(a; "G/L Budget Entry"."Budget Name") { }
                fieldelement(b; "G/L Budget Entry"."G/L Account No.") { }
                fieldelement(c; "G/L Budget Entry".Date) { }
                fieldelement(D; "G/L Budget Entry"."Global Dimension 1 Code") { }
                fieldelement(e; "G/L Budget Entry"."Global Dimension 2 Code") { }
                fieldelement(f; "G/L Budget Entry"."Budget Dimension 3 Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(g; "G/L Budget Entry"."Budget Dimension 4 Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(h; "G/L Budget Entry".Description) { }
                fieldelement(i; "G/L Budget Entry".Amount) { }
                fieldelement(j; "G/L Budget Entry"."Entry No.") { }
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }
}

