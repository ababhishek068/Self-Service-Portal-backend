XmlPort 50006 "Journal Import"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'Grn';
                fieldelement(aa; "Gen. Journal Line"."Posting Date") { }
                fieldelement(h; "Gen. Journal Line"."Document No.") { }
                fieldelement(a; "Gen. Journal Line"."Account Type") { }
                fieldelement(h; "Gen. Journal Line"."Account No.") { }
                fieldelement(b; "Gen. Journal Line".Description) { }
                fieldelement(i; "Gen. Journal Line"."External Document No.") { }

                fieldelement(f; "Gen. Journal Line".Amount) { }
                fieldelement(k; "Gen. Journal Line"."Bal. Account Type") { }
                fieldelement(l; "Gen. Journal Line"."Bal. Account No.") { }
                fieldelement(m; "Gen. Journal Line"."Journal Template Name") { }
                fieldelement(n; "Gen. Journal Line"."Journal Batch Name") { }
                fieldelement(o; "Gen. Journal Line"."Line No.") { }

                fieldelement(p; "Gen. Journal Line"."Shortcut Dimension 1 Code") { }

                fieldelement(q; "Gen. Journal Line"."Shortcut Dimension 2 Code") { }

                trigger OnBeforeInsertRecord()
                begin
                    /*  if not Cust.Get("Gen. Journal Line"."Account No.") then begin
                     Cust.Init;
                     Cust."No.":="Gen. Journal Line"."Account No.";
                    // Cust.Name:=
                     Cust."Customer Posting Group":='Student';
                     Cust."Customer Type":=Cust."customer type"::Student;
                     Cust.Insert;
                     end; */


                    //  "Gen. Journal Line"."Journal Template Name":='GENERAL';
                    // "Gen. Journal Line"."Journal Batch Name":='TRANS';
                    // "Gen. Journal Line"."Bal. Account No.":='72001';
                    //"Gen. Journal Line"."Account Type":="Gen. Journal Line"."Account Type"::Customer;
                    //"Gen. Journal Line"."Bal. Account Type":="Gen. Journal Line"."Bal. Account Type"::"Bank Account";
                    // "Gen. Journal Line"."Line No.":="Gen. Journal Line"."Line No."+1;
                    //  "Gen. Journal Line"."Posting Date":=20130107D;
                    // "Gen. Journal Line"."Document No.":='Opening Bal';
                    /*
                       IF Cust.GET("Gen. Journal Line"."Account No.") THEN BEGIN
                       Cust.Blocked:=0;
                       Cust.MODIFY;
                       END;
                    */

                    // "Gen. Journal Line"."Account Type":="Gen. Journal Line"."Account Type"::Vendor;
                    // "Gen. Journal Line"."Bal. Account Type":="Gen. Journal Line"."Bal. Account Type"::"Bank Account";
                    //"Gen. Journal Line"."Journal Template Name":='General';
                    // "Gen. Journal Line"."Journal Batch Name":='default';

                end;
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }
}

