#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50991 "Requisition Register"
{
    DrillDownPageID = "Logical Framework Activity";
    LookupPageID = "Logical Framework Activity";

    fields
    {
        field(1;"Requestion No";Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Requestion No" <> xRec."Requestion No" then begin
                 ATMSetup.Get;
                  NoSeriesMgt.TestManual(ATMSetup."Requestion No");
                  "No. Series" := '';
                  if ATMReg.Get("ATM NO") then
                   "ATM Description":=ATMReg.Description;
                  "atm location":=ATMReg."Physical loation";
                  Bank:=ATMReg."Bank Abrreviation";
                 "ATM is Old or New":=ATMReg.Oldnew;
                end;
            end;
        }
        field(2;"Case Description";Text[150])
        {
        }
        field(3;"SR Number";Code[30])
        {
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
        field(8;Branch;Code[100])
        {
            TableRelation = "Post Code".City;
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
        field(13;"Requesting Engineer No";Code[10])
        {
            TableRelation = "HR-Employee"."No.";          
             trigger OnValidate()
            begin
                if hrenginer.Get("Requesting Engineer No")then
                  "Engineer Name":=hrenginer."First Name"+' ' +hrenginer."Last Name";
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
            Editable = true;
        }
        field(17;"Bill Client";Boolean)
        {
        }
        field(18;"ATM Type code";Code[50])
        {
            TableRelation = "ATM Model Setup".Code;

            trigger OnValidate()
            begin
                if Atmmodule.Get("ATM Type code") then begin
                "Atm Type":=Atmmodule."ATM Model";
                "Atm Dimensions":=Atmmodule.Dimension;
                "Camera Installed":=Atmmodule."Camera Installed";
                Cassettes:=Atmmodule.cassettes;
                "Receipt Printer":=Atmmodule."Receipt Printer";
                "Touch Screen":=Atmmodule."Touch Screen";
                "Screen Size":=Atmmodule."Screen Size";
                end;
            end;
        }
        field(19;"Atm Type";Text[50])
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
        field(26;"ATM NO";Code[10])
        {
            TableRelation = "ATM Register."."ATM No";

            trigger OnValidate()
            begin
                if ATMReg.Get("ATM NO")then
                  begin
                "Customer No":=ATMReg."Customer No";
                    "Customer Name":=ATMReg."Customer Name";
                    "Atm Type":=ATMReg."Atm model";
                    country:=ATMReg.country;
                    Street:=ATMReg.Street;
                    "Physical loation":=ATMReg."Physical loation";
                    Branch:=ATMReg.Branch;
                    "Atm Dimensions":=ATMReg."Atm Dimensions";
                    Cassettes:=ATMReg.Cassettes;
                    "Receipt Printer":=ATMReg."Receipt Printer";
                    "Touch Screen":=ATMReg."Touch Screen";
                    "Screen Size":=ATMReg."Screen Size";
                    "ATM Description":=ATMReg.Description;
                    "ATM is Old or New":=ATMReg.Oldnew;

                end;
            end;
        }
        field(27;issued;Boolean)
        {
        }
        field(28;"Date Escalated";Date)
        {
        }
        field(29;"Total Spares Order";Integer)
        {
        }
        field(30;"Must Check";Boolean)
        {
        }
        field(31;"Item No";Code[20])
        {
        }
        field(32;"Quantity Requested";Integer)
        {
            CalcFormula = sum("Component Line Register".Quantity where ("Requestion No"=field("Requestion No")));
            FieldClass = FlowField;
        }
        field(33;"Delivery Note No";Code[50])
        {
        }
        field(34;"Issued To";Text[100])
        {
        }
        field(35;"ATM Description";Text[50])
        {
        }
        field(36;"Where Do you want To Get Item";Option)
        {
            OptionCaption = ',Purchase,TRC';
            OptionMembers = ,Purchase,TRC;
        }
        field(37;Corrected;Boolean)
        {
            Editable = false;
        }
        field(38;"Issue Date";Date)
        {
        }
        field(39;"atm location";Text[50])
        {
        }
        field(40;"Case No";Code[20])
        {
        }
        field(41;"ATM NAME";Text[100])
        {
            CalcFormula = lookup("ATM Register.".Description where ("ATM No"=field("ATM NO")));
            FieldClass = FlowField;
        }
        field(42;Bank;Code[50])
        {
            TableRelation = "Bank Abbreviations"."abbr code";
        }
        field(43;entry;Integer)
        {
            AutoIncrement = true;
        }
        field(44;"Faulty returned";Boolean)
        {
        }
        field(45;"Returned date";Date)
        {
        }
        field(46;From;Code[10])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                if hrenginer.Get(From) then begin
                  "from name":=hrenginer."First Name"+' '+hrenginer."Last Name";
                  end;
                  "registered by":=UserId;
                  "Returned date":=Today;
            end;
        }
        field(47;"from name";Text[50])
        {
            Editable = false;
        }
        field(48;"registered by";Code[30])
        {
            Editable = false;
        }
        field(49;"trc receive";Boolean)
        {
        }
        field(50;"repaired by";Code[30])
        {
        }
        field(51;"repaired on";Date)
        {
        }
        field(52;"suspense acc";Boolean)
        {
        }
        field(53;Status;Option)
        {
            OptionCaption = 'New,Pending,Approved,Pending Approval,1st Approver,Second Approver,Third Approver';
            OptionMembers = New,Pending,Approved,"Pending Approval","1st Approver","Second Approver","Third Approver",rejected;
        }
        field(54;doctype;Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,JV,Member Withdrawal,Membership Reg,Loan Batches,Payment Voucher,Petty Cash,Loan,Interbank,Checkoff,Savings Product Opening,Standing Order,atmreq';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Withdrawal","Membership Reg","Loan Batches","Payment Voucher","Petty Cash",Loan,Interbank,Checkoff,"Savings Product Opening","Standing Order",atmreq;
        }
        field(55;"Return Date";Date)
        {
        }
        field(56;"ATM is Old or New";Option)
        {
            OptionCaption = ' ,New,Old';
            OptionMembers = " ",New,Old;
        }
        field(57;ReturnedByEng;Boolean)
        {
        }
        field(58;"Last Date Received";Date)
        {
        }
        field(59;"Engineer Receipt";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Requestion No",entry,"ATM NO")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Requestion No" = '' then begin
          ATMSetup.Get;
          ATMSetup.TestField(ATMSetup."Requestion No");
          "Requestion No":=NoSeriesMgt.GetNextNo(ATMSetup."Requestion No",Today,true);
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
        ATMReg: Record "ATM Register.";
}

