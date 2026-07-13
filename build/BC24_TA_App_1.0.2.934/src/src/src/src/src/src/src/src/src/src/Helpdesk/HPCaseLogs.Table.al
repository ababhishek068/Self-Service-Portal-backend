#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50989 "HP Case Logs"
{

    fields
    {
        field(1;"Case No";Code[20])
        {

            trigger OnValidate()
            begin

                if "Case No"<>xRec."Case No" then begin
                  Hpsetup.Get;
                  NoSeriesMgt.TestManual(Hpsetup."Cases nos");
                  "no series":='';
                  end;

            end;
        }
        field(2;"SLA No";Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(7;Duration;Duration)
        {
        }
        field(8;"SLA Strat Date";Date)
        {
        }
        field(9;"SLA Expiry Date";Date)
        {
            Description = 'Pending,Received,Resolved';

            trigger OnValidate()
            begin

                "SLA Expiry Date":="SLA Expiry Date";
            end;
        }
        field(10;Category;Text[50])
        {
        }
        field(11;Priority;Option)
        {
            OptionCaption = ',low,medium,high';
            OptionMembers = ,low,medium,high;
        }
        field(12;"Assign to";Code[10])
        {
            TableRelation = "HR-Employee"."No." where ("Global Dimension 1 Code"=filter('HP'));
        }
        field(13;"Issue Type";Option)
        {
            OptionCaption = ',Hardware,Software';
            OptionMembers = ,Hardware,Software;
        }
        field(14;"Support Type";Option)
        {
            OptionCaption = ',Desktop,Laptop,Printers,Server,Storage,Networking,Software,Security,UPS';
            OptionMembers = ,Desktop,Laptop,Printers,Server,Storage,Networking,Software,Security,UPS;
        }
        field(15;Model;Text[30])
        {
        }
        field(16;"Serial No";Code[30])
        {
        }
        field(17;"Product No";Code[30])
        {
        }
        field(18;"Warranty Type";Option)
        {
            Caption = 'No. Series';
            Editable = false;
            OptionCaption = ',PSG Warranty, PSG Non-Warranty,ESG Warranty,ESG Non-Warranty';
            OptionMembers = ,"PSG Warranty"," PSG Non-Warranty","ESG Warranty","ESG Non-Warranty";
            TableRelation = "No. Series";
        }
        field(19;"Issue Description";Text[100])
        {
        }
        field(20;"Additional Notes";Text[100])
        {
        }
        field(21;"Application Time";Time)
        {
        }
        field(22;"Receive User";Code[20])
        {
        }
        field(23;"Receive date";Date)
        {
        }
        field(24;"Receive Time";Time)
        {
        }
        field(25;"Resolved User";Code[50])
        {
        }
        field(26;"Resolved Date";Date)
        {
        }
        field(27;"Resolved Time";Time)
        {
        }
        field(28;"Caller Reffered To";Code[50])
        {
            TableRelation = User."User Name";

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("Caller Reffered To");
            end;

            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.ValidateUserID("Caller Reffered To");
            end;
        }
        field(29;"Received From";Code[20])
        {
        }
        field(31;"Contact Mode";Option)
        {
            OptionCaption = 'Physical,Phone Call,E-Mail,Letter';
            OptionMembers = Physical,"Phone Call","E-Mail",Letter;
        }
        field(32;"Calling For";Option)
        {
            OptionCaption = 'Inquiry,Request,Appreciation,Complaint,Criticism,Payment,Receipt,Loan Form,Housing';
            OptionMembers = Inquiry,Request,Appreciation,Complaint,Criticism,Payment,Receipt,"Loan Form",Housing;
        }
        field(33;"Date Sent";Date)
        {
        }
        field(34;"Time Sent";Time)
        {
        }
        field(35;"Sent By";Code[50])
        {
        }
        field(36;"Employer Cases types";Option)
        {
            Description = '//TA crm';
            OptionCaption = ',Receipt,Checkoff Advice,Refunds';
            OptionMembers = ,Receipt,"Checkoff Advice",Refunds;
        }
        field(68027;"ID No.";Code[50])
        {
            Description = '//TA crm';

            trigger OnValidate()
            begin
                /*IF "ID No."<>'' THEN BEGIN
                Cust.RESET;
                Cust.SETRANGE(Cust."ID No.","ID No.");
                Cust.SETRANGE(Cust."Customer Type",Cust."Customer Type"::Member);
                IF Cust.FIND('-') THEN BEGIN
                IF Cust."No." <> "No." THEN
                   ERROR('ID No. already exists');
                END;
                END;
                
                
                
                Vend2.RESET;
                Vend2.SETRANGE(Vend2."Creditor Type",Vend2."Creditor Type"::Account);
                Vend2.SETRANGE(Vend2."Staff No","Payroll/Staff No");
                IF Vend2.FIND('-') THEN BEGIN
                REPEAT
                Vend2."ID No.":="ID No.";
                Vend2.MODIFY;
                UNTIL Vend2.NEXT = 0;
                END;
                    */

            end;
        }
        field(68028;Address;Code[50])
        {
            Description = '//TA crm';
        }
        field(68029;city;Code[50])
        {
            Description = '//TA crm';
        }
        field(68030;"company No";Code[50])
        {
            Description = '//TA crm';
        }
        field(68031;"Company Name";Text[100])
        {
            Description = '//TA crm';
        }
        field(68032;"First Name";Text[30])
        {
            Description = '//TA crm';
        }
        field(68033;SurName;Text[30])
        {
            Description = '//TA crm';
        }
        field(68034;"Last Name";Text[30])
        {
            Description = '//TA crm';
        }
        field(68035;"Country/Region Code";Code[30])
        {
            Description = '//TA crm';
        }
        field(68036;"Salesperson Code";Code[30])
        {
            Description = '//TA crm';
        }
        field(68037;"User comment";Text[250])
        {
            Description = '//TA crm';
        }
        field(68038;"Fosa account";Code[30])
        {
        }
        field(68039;"Loan No";Code[10])
        {
        }
        field(68041;"Available Current Balance";Decimal)
        {
        }
        field(68042;Send;Boolean)
        {
        }
        field(68043;"Company Address";Code[50])
        {
        }
        field(68044;"Company postal code";Code[10])
        {
            TableRelation = "Post Code";
        }
        field(68045;"Company Telephone";Code[15])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(68046;"Company Email";Text[30])
        {
            ExtendedDatatype = EMail;
        }
        field(68047;"Company website";Text[30])
        {
            ExtendedDatatype = URL;
        }
        field(68053;"Location/Side";Code[50])
        {
            TableRelation = Location.Code;
        }
        field(68056;"Responsible Engineer";Code[10])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(68057;"Engineer Name";Text[30])
        {
        }
        field(68058;"no series";Code[10])
        {
        }
        field(68059;"Created by";Text[50])
        {
        }
        field(68060;"Received Date";Date)
        {
        }
        field(68061;"Engineer assigned";Boolean)
        {
        }
        field(68062;"Case resolved status";Boolean)
        {
        }
        field(68063;engmail;Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"Case No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if "Case No"='' then begin
          Hpsetup.Get;
          Hpsetup.TestField(Hpsetup."Cases nos");
          NoSeriesMgt.GetNextNo(Hpsetup."Cases nos",today,true);
          "Created by":=UserId;
          "Received Date":=Today;
          end;

    end;

    var
        Hpsetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        UserMgt: Codeunit "User Setup Management";
}

