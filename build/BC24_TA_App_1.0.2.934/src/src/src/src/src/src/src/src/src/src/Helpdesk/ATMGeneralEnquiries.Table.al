#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50984 "ATM General Enquiries"
{

    fields
    {
        field(1;No;Code[20])
        {

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                  SalesSetup.Get;
                  NoSeriesMgt.TestManual(SalesSetup."Crm logs Nos");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;"Client Code";Code[20])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                
                if "Calling As"="calling as"::"As ATM Member" then begin
                Cust.Reset;
                Cust.SetRange(Cust."No.","Client Code");
                if Cust.Find('-') then begin
                Cust.CalcFields(Cust.Balance,"Invoice Amounts");
                "Member Name":=Cust.Name;
                "Current Deposits":= Cust.Balance;
                "ID No":= Cust."TIN No";
                "Phone No":=Cust."Phone No.";
                //"Passport No":= Cust."Passport No.";
                Email:=Cust."E-Mail";
                
                Gender:=Cust.Gender;
                //Status:=Cust.cust
                Address:=Cust.Address;
                city:=Cust.City;
                //"company No":=Cust.sw;
                //"Company Name":=Cust."Employer Name";
                
                Source:=Cust."Customer Posting Group";
                end;
                end else
                if "Calling As"="calling as"::"As ATM Member" then begin
                "Member Name":=PRD.Name;
                "Phone No":=PRD."Phone No.";
                
                end
                /*
                END ELSE
                IF "Calling As"="Calling As"::"Safaricom Kiosks" THEN BEGIN
                */

            end;
        }
        field(3;"Member Name";Text[60])
        {
        }
        field(4;"Payroll No";Code[20])
        {
        }
        field(5;"Loan Balance";Decimal)
        {
        }
        field(6;"Current Deposits";Decimal)
        {
        }
        field(7;"Holiday Savings";Decimal)
        {
        }
        field(8;Description;Text[250])
        {
        }
        field(9;Status;Option)
        {
            Description = 'Pending,Received,Resolved';
            OptionCaption = ' ,Pending,Received,Resolved';
            OptionMembers = " ",Pending,Received,Resolved;

            trigger OnValidate()
            begin

                Status:=Status;
            end;
        }
        field(10;"ID No";Code[20])
        {
        }
        field(11;"Phone No";Text[30])
        {
        }
        field(12;"Passport No";Text[30])
        {
        }
        field(13;Email;Text[60])
        {
        }
        field(14;Gender;Option)
        {
            Description = 'Male,Female';
            OptionCaption = 'Male,Female';
            OptionMembers = Male,Female;
        }
        field(15;"SR Number";Code[20])
        {
        }
        field(16;"Share Capital";Decimal)
        {
        }
        field(17;Source;Code[20])
        {
            Description = 'BOSA,FOSA';
        }
        field(18;"No. Series";Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(19;"Application User";Code[20])
        {
        }
        field(20;"Application Date";Date)
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
        field(30;"Calling As";Option)
        {
            OptionCaption = ',As ATM Member,As New Customer,Kiosks';
            OptionMembers = ,"As ATM Member","As New Customer",Kiosks;
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
            Description = '//surestep crm';
        }
        field(36;"Employer Cases types";Option)
        {
            OptionCaption = ',Receipt,Checkoff Advice,Refunds';
            OptionMembers = ,Receipt,"Checkoff Advice",Refunds;
        }
        field(68027;"ID No.";Code[50])
        {
            Description = '//surestep crm';

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
            Description = '//surestep crm';
        }
        field(68029;city;Code[50])
        {
            Description = '//surestep crm';
        }
        field(68030;"company No";Code[50])
        {
            Description = '//surestep crm';
        }
        field(68031;"Company Name";Text[100])
        {
            Description = '//surestep crm';
        }
        field(68032;"First Name";Text[30])
        {
            Description = '//surestep crm';
        }
        field(68033;SurName;Text[30])
        {
            Description = '//surestep crm';
        }
        field(68034;"Last Name";Text[30])
        {
            Description = '//surestep crm';
        }
        field(68035;"Country/Region Code";Code[30])
        {
            Description = '//surestep crm';
        }
        field(68036;"Salesperson Code";Code[30])
        {
            Description = '//surestep crm';
        }
        field(68037;"User comment";Text[250])
        {
            Description = '//surestep crm';
        }
        field(68038;"Fosa account";Code[30])
        {
        }
        field(68039;"Loan No";Code[10])
        {

            trigger OnValidate()
            begin
                // if Loans.Get("Loan No") then begin
                //   Loans.CalcFields(Loans."Outstanding Balance");
                //   "Loan Balance":=Loans."Outstanding Balance";
                //   Message('Loan balance is %1',"Loan Balance");
                //   end;
            end;
        }
        field(68040;"Type of cases";Option)
        {
            NotBlank = true;
            OptionCaption = ',Repairs,Repairs/PM,New Installation,Hardware configuration,Software Upgrade,ATM Relocation,Assessments,preventive maintenance,Project';
            OptionMembers = ,Repairs,"Repairs/PM","New Installation","Hardware configuration","Software Upgrade","ATM Relocation",Assessments,"preventive maintenance",Project;
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
        field(68051;"ATM No";Code[10])
        {
            TableRelation = "ATM Register."."ATM No";

            trigger OnValidate()
            begin
                if AtmObject.Get("ATM No")then begin
                  if AtmObject."ATM Status"=AtmObject."atm status"::Deccommisioned then
                    Error('This ATM is already Deccommissioned, Kindly confirm details');
                  "ATM Name":=AtmObject.Description;
                  "Location/Side":=AtmObject.Branch;
                  "Branch/CIT/lobby":=AtmObject."Branch/CIT/Lobby";
                  "Bank Abbr":=AtmObject."Bank Abrreviation";
                  "Serial Number":=AtmObject."Serial Number";
                  "Client Code":=AtmObject."Customer No";
                  "Member Name":=AtmObject."Customer Name";

                  "Responsible Engineer":=AtmObject."Responsible Engineer ID";
                  "Engineer Name":=AtmObject."Engineer Name";
                   "Responsible manager":=AtmObject."Manager ID";
                  "Manager Name":=AtmObject."Manager Name";
                  "Atm Type":=AtmObject."Atm model";
                "Atm Dimensions":=AtmObject."Atm Dimensions";
                "Camera Installed":=AtmObject."Camera Installed";
                Cassettes:=AtmObject.Cassettes;
                "Receipt Printer":=AtmObject."Receipt Printer";
                "Touch Screen":=AtmObject."Touch Screen";
                "Screen Size":=AtmObject."Screen Size";



                  end;
            end;
        }
        field(68052;"ATM Name";Text[50])
        {
        }
        field(68053;"Location/Side";Code[50])
        {
            TableRelation = Location.Code;
        }
        field(68055;"Serial Number";Code[30])
        {
        }
        field(68056;"Responsible Engineer";Code[10])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(68057;"Engineer Name";Text[30])
        {
        }
        field(68058;"ATM Type code";Code[50])
        {
            TableRelation = "ATM Model Setup".Code;

            trigger OnValidate()
            begin
                if Atmmodule.Get("ATM Type code") then begin
                "Atm Type":=Atmmodule."ATM Model";
                //"branch/CIT/lobby":=Atmmodule.
                "Atm Dimensions":=Atmmodule.Dimension;
                "Camera Installed":=Atmmodule."Camera Installed";
                Cassettes:=Atmmodule.cassettes;
                "Receipt Printer":=Atmmodule."Receipt Printer";
                "Touch Screen":=Atmmodule."Touch Screen";
                "Screen Size":=Atmmodule."Screen Size";
                end;
            end;
        }
        field(68059;"Atm Type";Text[50])
        {
        }
        field(68060;"Atm Dimensions";Code[30])
        {
        }
        field(68061;"Camera Installed";Option)
        {
            OptionMembers = ,Yes,Nos;
        }
        field(68062;Cassettes;Code[10])
        {
        }
        field(68063;"Receipt Printer";Code[50])
        {
        }
        field(68064;"Touch Screen";Option)
        {
            OptionCaption = ',Yes,No';
            OptionMembers = ,Yes,No;
        }
        field(68065;"Screen Size";Code[30])
        {
        }
        field(68066;"Send &Allocate";Boolean)
        {
        }
        field(68067;"Bank Abbr";Code[30])
        {
            TableRelation = "Bank Abbreviations"."abbr code";
        }
        field(68068;"Branch/CIT/lobby";Option)
        {
            OptionCaption = 'Branch,CIT,Lobby';
            OptionMembers = Branch,CIT,Lobby;
        }
        field(68069;"Responsible manager";Code[30])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(68070;"Manager Name";Text[50])
        {
        }
        field(68071;Category;Code[30])
        {
            TableRelation = "Atm Case Categories"."category Code";
        }
        field(68072;"Kiosk No";Code[10])
        {
            TableRelation = "Safaricom Kiosks"."Kiosk No";

            trigger OnValidate()
            begin
                kioskregister.Reset;
                kioskregister.SetRange(kioskregister."Kiosk No","Kiosk No");
                if kioskregister.Find('-') then
                "Kiosk Description":=kioskregister.Description;
                "Kiosk Customer No":=kioskregister."Customer No";
                "Kiosk Customer Name":=kioskregister."Customer Name";
                Latitude:=kioskregister.latitude;
                Longitude:=kioskregister.longitude;
                "Store address":=kioskregister."Store address";
                "Kiosk Physical Location":=kioskregister."Physical loation";
                "Weekday openning":=kioskregister."weekday opening";
                "Weekday Closing":=kioskregister."weekday closing";
                "weekend and holidays":=kioskregister."weekday and holidays";
            end;
        }
        field(68073;"Kiosk Description";Text[50])
        {
        }
        field(68074;Latitude;Code[50])
        {
        }
        field(68075;Longitude;Code[50])
        {
        }
        field(68076;"Weekday openning";Time)
        {
        }
        field(68077;"Weekday Closing";Time)
        {
        }
        field(68078;"Store address";Text[100])
        {
        }
        field(68079;"weekend and holidays";Text[100])
        {
        }
        field(68080;"Kiosk Customer No";Code[10])
        {
        }
        field(68081;"Kiosk Customer Name";Text[50])
        {
        }
        field(68082;"Kiosk Physical Location";Text[150])
        {
        }
        field(68083;Notes;Text[200])
        {
        }
        field(68084;"Case belongs to";Option)
        {
            OptionCaption = ',ATM,OTHER';
            OptionMembers = ,ATM,OTHER;
        }
        field(68085;"Reason For Involuntary Closure";Text[100])
        {
        }
    }

    keys
    {
        key(Key1;No)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if No = '' then begin
          SalesSetup.Get;
          SalesSetup.TestField(SalesSetup."Crm logs Nos");
          "No. Series":=NoSeriesMgt.GetNextNo(SalesSetup."Crm logs Nos",Today,true);
        end;
    end;

    var
        SalesSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        //Loans: Record UnknownRecord51516371;
        //GenSetUp: Record UnknownRecord51516398;
        Cust: Record Customer;
        PVApp: Record "Payments Header";
        UserMgt: Codeunit "User Setup Management";
        PRD: Record Customer;
        AtmObject: Record "ATM Register.";
        Atmmodule: Record "ATM Model Setup";
        kioskregister: Record "Safaricom Kiosks";
}

