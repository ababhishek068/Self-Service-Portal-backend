#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50987 "Component Line Register-Pendin"
{

    fields
    {
        field(1;"Part No";Code[30])
        {
            TableRelation = "ATM Hardware components"."Part No";

            trigger OnValidate()
            begin
                /*ObjAtmreg.SETRANGE(ObjAtmreg."Requestion No","Atm No");
                IF ObjAtmreg.FIND('-') THEN
                  IF ObjAtmreg."Part Category"<>ObjAtmreg."Part Category"::Hardware THEN
                    ERROR('Part category must be Hardware');*/
                  if ATMHRD.Get("Part No")then
                  Description:=ATMHRD.Description;

            end;
        }
        field(2;Description;Text[50])
        {
        }
        field(3;Quantity;Integer)
        {
        }
        field(4;"Unit price";Decimal)
        {

            trigger OnValidate()
            begin
                "Total Amount":=Quantity*"Unit price";
            end;
        }
        field(5;"Atm No";Code[30])
        {
            TableRelation = "ATM Register."."ATM No";

            trigger OnValidate()
            begin
                atmreg.Reset;
                atmreg.SetRange(atmreg."ATM No","Atm No");
                if atmreg.Find('-') then
                  "bank abrr":=atmreg."Bank Abrreviation";
            end;
        }
        field(6;"Total Amount";Decimal)
        {
        }
        field(7;Category;Option)
        {
            OptionMembers = Hardware;
        }
        field(8;"Entry No";Integer)
        {
        }
        field(10;Status;Option)
        {
            OptionCaption = 'Working,Faulty,Repaired,Beyond Repaire';
            OptionMembers = Working,Faulty,Repaired,"Beyond Repaire";
        }
        field(11;"Requestion No";Code[10])
        {
            TableRelation = "Requisition Register-Pending"."Requestion No";
        }
        field(12;"Requestion Send";Boolean)
        {
        }
        field(13;"Item No.";Code[10])
        {
        }
        field(14;"To be Billed";Boolean)
        {
        }
        field(15;Barcode;Code[10])
        {

            trigger OnValidate()
            begin
                
                      /*IF pendingline.Barcode='N/M' THEN BEGIN
                      pendingline.RESET;
                          pendingline.SETRANGE(pendingline.Barcode,Barcode);
                          IF pendingline.FIND('-') THEN BEGIN
                            IF(pendingline."Part status"<>pendingline."Part status"::Returned) THEN BEGIN
                              ERROR(Barcode+' Already exists');
                              END;
                            END;
                            Validatebar.RESET;
                Validatebar.SETRANGE(Validatebar.Barcode,Barcode);
                
                IF Validatebar.FIND('-')THEN BEGIN
                
                
                      IF (Validatebar."Part status"<>Validatebar."Part status"::Returned) THEN BEGIN
                        IF Validatebar."Faulty Barcode"='' THEN BEGIN
                
                          ERROR(Barcode+' '+'Already exist');
                          END;
                
                    END;
                      END;
                            END;*/

            end;
        }
        field(16;Available;Boolean)
        {
            Editable = false;
        }
        field(17;"Error message";Text[100])
        {
        }
        field(18;"Part status";Option)
        {
            OptionCaption = 'Pending,Issued,Returned';
            OptionMembers = Pending,Issued,Returned;
        }
        field(19;Returned;Boolean)
        {
            Editable = false;
        }
        field(20;"bank abrr";Code[30])
        {
            TableRelation = "Bank Abbreviations"."abbr code";
        }
        field(21;Ship;Boolean)
        {
        }
        field(22;Exist;Boolean)
        {
        }
        field(23;"Old Requistion No";Code[30])
        {
            TableRelation = "Requisition Register"."Requestion No";
        }
        field(24;"case no";Code[10])
        {
        }
        field(25;return;Boolean)
        {
        }
        field(26;"issue date";Date)
        {
        }
        field(45;"ATM CodeN";Code[30])
        {
            TableRelation = "ATM Register."."ATM No";

            trigger OnValidate()
            begin
                if "ATM CodeN"<>'' then begin
                atmreg.Reset;
                atmreg.SetRange(atmreg."ATM No","ATM CodeN");
                if atmreg.Find('-') then begin
                  "ATM DescrN":=atmreg.Description;
                  "ATM SnN":=atmreg."Serial Number";

                end;
                end else if "ATM CodeN"='' then begin
                  "ATM DescrN":='';
                  "ATM SnN":='';

                end;
            end;
        }
        field(46;"ATM DescrN";Text[100])
        {
        }
        field(47;"ATM SnN";Code[50])
        {
        }
        field(48;Deccommmissioned;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Requestion No","Entry No","Part No","Atm No",Barcode,"Old Requistion No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ATMHRD: Record "ATM Hardware components";
        ObjAtmreg: Record  "Requisition Register";
        Validatebar: Record "Component Line Register";
        atmreg: Record "ATM Register.";
        pendingline: Record "Requisition Register-Pending";
        decolines: Record "Decommisioned ATMs Parts";
}

