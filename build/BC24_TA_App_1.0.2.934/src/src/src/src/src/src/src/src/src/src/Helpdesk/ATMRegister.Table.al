#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50985 "ATM Register."
{
    DrillDownPageID = "Int. Audit Meeting Minutes";
    LookupPageID = "Int. Audit Meeting Minutes";

    fields
    {
        field(1;"ATM No";Code[10])
        {
            Editable = true;

            trigger OnValidate()
            begin
                 if "ATM No" <> xRec."ATM No" then begin
                ATMSetup.Get;
                NoSeriesMgt.TestManual(ATMSetup."ATM Nos");
                "No. Series" := '';
                end;
            end;
        }
        field(2;Description;Text[50])
        {

            trigger OnValidate()
            begin
                //IF "Physical loation"='' THEN
                  //ERROR('Kindly, add the physical location first');
                //IF "Bank Abrreviation"='' THEN
                  //ERROR('Kindly, add the Bank Abbreviation first');
                  //felix
            end;
        }
        field(3;"Serial Number";Code[30])
        {

            trigger OnValidate()
            begin
                atmreg.Reset;
                atmreg.SetRange(atmreg."Serial Number","Serial Number");
                if atmreg.Find('-') then begin

                  Error('This Serial No. is already used for ATM: '+atmreg."ATM No");
                end;
            end;
        }
        field(4;"Requestion date";Date)
        {
        }
        field(5;"Customer No";Code[10])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                 if cust.Get("Customer No") then
                   "Customer Name":=cust.Name;
            end;
        }
        field(6;"Customer Name";Text[50])
        {
        }
        field(7;country;Code[30])
        {
            TableRelation = "Country/Region".Code;
        }
        field(8;Branch;Code[50])
        {
        }
        field(9;Street;Code[30])
        {
        }
        field(10;"Physical loation";Text[50])
        {
        }
        field(11;"Part Category";Option)
        {
            BlankZero = true;
            OptionCaption = ',Hardware,Software';
            OptionMembers = ,Hardware,Software;
        }
        field(12;"No. Series";Code[20])
        {
        }
        field(13;"Responsible Engineer ID";Code[10])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            begin
                if hrenginer.Get("Responsible Engineer ID")then
                  "Engineer Name":=hrenginer."Full Name";
            end;
        }
        field(14;"Engineer Name";Text[30])
        {
        }
        field(15;"Created By";Code[30])
        {
            Editable = false;
        }
        field(16;Created;Boolean)
        {
            Editable = false;
        }
        field(17;"Requestion Send";Boolean)
        {
        }
        field(18;"ATM model code";Code[50])
        {
            TableRelation = "ATM Model Setup".Code;

            trigger OnValidate()
            begin
                if Atmmodule.Get("ATM model code") then begin
                "Atm model":=Atmmodule."ATM Model";
                "Atm Dimensions":=Atmmodule.Dimension;
                "Camera Installed":=Atmmodule."Camera Installed";
                Cassettes:=Atmmodule.cassettes;
                "Receipt Printer":=Atmmodule."Receipt Printer";
                "Touch Screen":=Atmmodule."Touch Screen";
                "Screen Size":=Atmmodule."Screen Size";
                end;
            end;
        }
        field(19;"Atm model";Text[50])
        {
        }
        field(20;"Atm Dimensions";Code[30])
        {
        }
        field(21;"Camera Installed";Option)
        {
            OptionMembers = ,Yes,Nos;
        }
        field(22;Cassettes;Code[10])
        {
        }
        field(23;"Receipt Printer";Code[50])
        {
        }
        field(24;"Touch Screen";Option)
        {
            OptionCaption = ',Yes,No';
            OptionMembers = ,Yes,No;
        }
        field(25;"Screen Size";Code[30])
        {
        }
        field(26;"ATM Status";Option)
        {
            OptionCaption = 'Active,Inactive,Relocated,Deccommisioned';
            OptionMembers = Active,Inactive,Relocated,Deccommisioned;
        }
        field(27;"Total Spares In Hand";Integer)
        {
            CalcFormula = sum("Hardware Component Line".Quantity where ("Atm No"=field("ATM No")));
            FieldClass = FlowField;
        }
        field(28;"Faulty Spares";Integer)
        {
            CalcFormula = sum("Hardware Component Line".Quantity where ("Atm No"=field("ATM No"),
                                                                        Status=filter(Faulty)));
            FieldClass = FlowField;
        }
        field(29;"Repared Spares";Integer)
        {
            CalcFormula = sum("Hardware Component Line".Quantity where ("Atm No"=field("ATM No"),
                                                                        Status=filter(Repaired)));
            FieldClass = FlowField;
        }
        field(30;"ATM Invoices";Integer)
        {
        }
        field(31;"Total Cost";Decimal)
        {
            CalcFormula = sum("Hardware Component Line"."Total Amount" where ("Atm No"=field("ATM No")));
            FieldClass = FlowField;
        }
        field(32;"ATM code";Code[20])
        {
        }
        field(33;"Bank Abrreviation";Code[20])
        {
            TableRelation = "Bank Abbreviations"."abbr code";
        }
        field(34;"Branch/CIT/Lobby";Option)
        {
            OptionCaption = 'Branch,CIT,Lobby';
            OptionMembers = Branch,CIT,Lobby;
        }
        field(35;"Manager ID";Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                if hremp.Get("Manager ID") then begin
                  "Manager Name":=hremp."First Name"+' '+hremp."Middle Name"+' '+hremp."Last Name";
                  "Manager Email":=hremp."E-Mail";
                  if "Manager Email"='' then begin
                    "Manager Email":=hremp."Company E-Mail";
                    end
                  end;
            end;
        }
        field(36;"Manager Name";Text[50])
        {
        }
        field(37;"Manager Email";Text[50])
        {
        }
        field(38;Oldnew;Option)
        {
            OptionCaption = ' ,OLD,NEW';
            OptionMembers = " ",OLD,NEW;
        }
        field(39;marked;Boolean)
        {
        }
       
    }

    keys
    {
        key(Key1;"ATM No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "ATM No" = '' then begin
          ATMSetup.Get;
          ATMSetup.TestField(ATMSetup."ATM Nos");
          "ATM No":=NoSeriesMgt.GetNextNo(ATMSetup."ATM Nos",Today,true);
          "Requestion date":=Today;
          "Created By":=UserId;
        end;
    end;

    var
        ATMSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        hrenginer: Record "HR-Employee";
        cust: Record Customer;
        Atmmodule: Record "ATM Model Setup";
        hremp: Record "HR-Employee";
        atmreg: Record "ATM Register.";
        decommisonedATMS: Record "Decommisioned ATMs";
}

