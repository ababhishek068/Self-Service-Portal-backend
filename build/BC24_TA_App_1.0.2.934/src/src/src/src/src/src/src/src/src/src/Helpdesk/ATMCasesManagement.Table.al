Table 51001 "ATM Cases Management"
{
    // DrillDownPageID = UnknownPage55596;
    // LookupPageID = UnknownPage55596;

    fields
    {
        field(1;"Case Number";Code[20])
        {
        }
        field(2;"Job card";Blob)
        {
            SubType = Bitmap;
        }
        field(3;"Date of Complaint";Date)
        {
        }
        field(4;"Type of cases";Option)
        {
            NotBlank = true;
            OptionCaption = ',Repairs,Repairs/PM,New Installation,Hardware configuration,Software Upgrade,ATM Relocation,Assessments,preventive maintenance,Project';
            OptionMembers = ,Repairs,"Repairs/PM","New Installation","Hardware configuration","Software Upgrade","ATM Relocation",Assessments,"preventive maintenance",Project;
        }
        field(5;"Recommended Action";Code[50])
        {
        }
        field(6;"Case Description";Text[250])
        {
        }
        field(7;Accuser;Code[50])
        {
        }
        field(8;test;Code[10])
        {
        }
        field(9;test1;Code[10])
        {
        }
        field(10;"Action Taken";Text[150])
        {
        }
        field(11;"Date To Settle Case";Date)
        {
        }
        field(12;"Document Link";Text[200])
        {
        }
        field(13;"solution Remarks";Code[50])
        {
        }
        field(14;Comments;Text[250])
        {
        }
        field(15;"Case Solved";Boolean)
        {
        }
        field(16;"Body Handling The Complaint";Code[10])
        {
        }
        field(17;Recomendations;Text[150])
        {
        }
        field(18;Implications;Integer)
        {
        }
        field(19;"Support Documents";Option)
        {
            OptionMembers = Yes,No;
        }
        field(20;"Policy Guidlines In Effect";Code[10])
        {
        }
        field(21;Status;Option)
        {
            Editable = true;
            OptionCaption = 'Open,Assigned,Resolved';
            OptionMembers = Open,Assigned,Resolved;
        }
        field(22;"Mode of Lodging the Complaint";Text[30])
        {
        }
        field(23;"No. Series";Code[20])
        {
        }
        field(24;"Resource Assigned";Code[30])
        {
            TableRelation = "HR-Employee"."No.";

            // trigger OnLookup()
            // var
            //     //UserMgt: Codeunit "User Management";
            // begin
            // end;

            trigger OnValidate()
            begin


                if HREngineers.Get("Resource Assigned") then
                  "Assigned name":=HREngineers."First Name"+' '+HREngineers."Middle Name"+' '+HREngineers."Last Name";
            end;
        }
        field(25;Selected;Boolean)
        {
        }
        field(26;"Closed By";Code[20])
        {
        }
        field(28;"Caller Reffered To";Code[50])
        {
            TableRelation = User."User Name";

            // trigger OnLookup()
            // var
            //     UserMgt: Codeunit "User Management";
            // begin
            //     UserMgt.LookupUserID("Caller Reffered To");
            // end;

            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.ValidateUserID("Caller Reffered To");
            end;
        }
        field(29;"Received From";Code[50])
        {
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
        field(36;SLA;Option)
        {
            OptionCaption = ',24HRS,48HRS,72HRS';
            OptionMembers = ,"24HRS","48HRS","72HRS";

            trigger OnValidate()
            begin
                if SLA=Sla::"24HRS"then
                  CPeriod:=1;
                if SLA=Sla::"48HRS"then
                CPeriod:=2;
                if SLA=Sla::"72HRS" then
                CPeriod:=3;
                //*** validate
                currYear := Date2dmy(Today,3);
                StartDate := 0D;
                EndDate := 0D;
                Month:=Date2dmy("Case Received  Date",2);
                DAY:=Date2dmy("Case Received  Date",1);


                StartDate := Dmy2date(1, Month, currYear); // StartDate will be the date of the first day of the month

                if Month=12 then begin
                Month:=0;
                currYear:=currYear+1;

                end;
                //EndDate := DMY2DATE(1, Month, currYear)-1;
                "Date To Settle Case":=CalcDate(Format(CPeriod)+'D',"Case Received  Date");
                //"Date To Settle Case":=CALCDATE(FORMAT(CPeriod)+'D',TODAY);
            end;
        }
        field(37;"Case Received  Date";Date)
        {
            Editable = false;
        }
        field(38;"Case belongs to";Option)
        {
            OptionCaption = ',ATM,OTHER';
            OptionMembers = ,ATM,OTHER;
        }
        field(3963;"Responsibility Center";Code[10])
        {
            TableRelation = "Responsibility Center".Code;

            trigger OnValidate()
            begin
                "Responsibility Center":='ATM';
            end;
        }
        field(3964;"Client Code";Code[10])
        {
            TableRelation = Customer."No." where ("Customer Posting Group"=filter('ATM'|'HP'));

            trigger OnValidate()
            begin

                if atmregister.Get("ATM No") then begin
                "bank abbre":=atmregister."Bank Abrreviation";
                  "ATM Name":=atmregister.Description;
                  "manager ID":=atmregister."Manager ID";

                end;
            end;
        }
        field(3965;"Fosa Account";Code[50])
        {
            TableRelation = Vendor."No.";
        }
        field(3966;"Account Name";Text[50])
        {
        }
        field(3967;"loan no";Code[10])
        {
            //TableRelation = "Loans Register";
        }
        field(3968;"Receive User";Code[50])
        {
            TableRelation = User."User Name";
        }
        field(3969;"Receive date";Date)
        {
        }
        field(3970;"Receive Time";Time)
        {
        }
        field(3971;"Resolved User";Code[50])
        {
            TableRelation = User."User Name";
        }
        field(3972;"Resolved Date";Date)
        {
        }
        field(3973;"Resolved Time";Time)
        {
        }
        field(50000;OldNew;Option)
        {
            OptionCaption = ' ,OLD,NEW';
            OptionMembers = " ",OLD,NEW;
        }
        field(68030;"company No";Code[50])
        {
            Description = '//surestep crm';
        }
        field(68031;"Company Name";Text[100])
        {
            Description = '//surestep crm';
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
        field(68048;"Resource1 Name";Text[30])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(68049;"Resource2 Name";Text[30])
        {
        }
        field(68050;"Assigned name";Text[30])
        {
        }
        field(68051;"ATM No";Code[10])
        {
            TableRelation = "ATM Requestion Register"."Requestion No";

            trigger OnValidate()
            begin

                if AtmObject.Get("ATM No")then begin
                  //"ATM Name":=AtmObject.at;
                  "Location/Side":=AtmObject.Branch;
                  "Case Description":=AtmObject."Case Description";
                  "Serial Number":=AtmObject."SR Number";
                  "Responsible Engineer":=AtmObject."Requesting Engineer No";
                  "Engineer Name":=AtmObject."Engineer Name";
                  "Client Code":=AtmObject."Customer No";
                  "Account Name":=AtmObject."Customer Name";
                  "ATM Type":=AtmObject."Atm Type";
                "Atm Dimensions":=AtmObject."Atm Dimensions";
                "Camera Installed":=AtmObject."Camera Installed";
                Cassettes:=AtmObject.Cassettes;
                "Receipt Printer":=AtmObject."Receipt Printer";
                "Touch Screen":=AtmObject."Touch Screen";
                "Screen Size":=AtmObject."Screen Size";

                 atmgenenq.Reset;
                 atmgenenq.SetRange(atmgenenq."ATM No","ATM No");
                 if atmgenenq.Find('-') then
                   begin
                     "manager ID":=atmgenenq."Responsible manager";
                     "bank abbre":=atmgenenq."Bank Abbr";
                      end
                  end;

                if atmregister.Get("ATM No") then
                  "bank abbre":=atmregister."Bank Abrreviation";


            end;
        }
        field(68052;"ATM Name";Text[50])
        {
        }
        field(68053;"Location/Side";Code[50])
        {
            TableRelation = Location.Code;
        }
        field(68054;"ATM Type";Code[50])
        {
        }
        field(68055;"Serial Number";Code[30])
        {
        }
        field(68056;"Responsible Engineer";Code[15])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(68057;"Engineer Name";Text[30])
        {
            TableRelation = "HR-Employee";
        }
        field(68060;"Atm Dimensions";Code[50])
        {
        }
        field(68061;"Camera Installed";Option)
        {
            OptionMembers = ,Yes,Nos;
        }
        field(68062;Cassettes;Code[10])
        {
        }
        field(68063;"Receipt Printer";Code[100])
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
        field(68066;"Send&Allocate";Boolean)
        {
        }
        field(68067;"SR Number";Code[20])
        {
        }
        field(68068;"Resource #1";Code[15])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                if HREngineers.Get("Resource #1")then
                  "Resource1 Name":=HREngineers."First Name"+' '+HREngineers."Middle Name"+' '+HREngineers."Last Name";
                "Resource Assigned":="Resource1 Name";
                Email:=HREngineers."E-Mail";
                EmpId:=HREngineers."TIN No.";
                "Employee No":=HREngineers."No.";

                if atmregister.Get("ATM No") then
                "manager Email":=atmregister."Manager Email";


            end;
        }
        field(68069;"Resource#2";Code[15])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin


                 if HREngineers.Get("Resource#2")then
                "Resource2 Name":=HREngineers."First Name"+' '+HREngineers."Middle Name"+' '+HREngineers."Last Name";
            end;
        }
        field(68070;Facilidated;Boolean)
        {
        }
        field(68071;"Custodian Name";Text[50])
        {
        }
        field(68072;DATE;Date)
        {
        }
        field(68073;"Arrival Time";Time)
        {
        }
        field(68074;"Waiting Time";Duration)
        {
        }
        field(68075;"Resolution time";Time)
        {
        }
        field(68077;"Cash Dispenser";Option)
        {
            OptionCaption = ',ok,not ok, not applicable';
            OptionMembers = ,ok,"not ok"," not applicable";
        }
        field(68078;"Cash Deposit";Option)
        {
            OptionCaption = ',ok,not ok, not applicable';
            OptionMembers = ,ok,"not ok"," not applicable";
        }
        field(68079;"Envelope Deposit";Option)
        {
            OptionCaption = ',ok,not ok, not applicable';
            OptionMembers = ,ok,"not ok"," not applicable";
        }
        field(68080;"Receipt Printer status";Option)
        {
            OptionCaption = ',ok,not ok, not applicable';
            OptionMembers = ,ok,"not ok"," not applicable";
        }
        field(68081;"Journal printer status";Option)
        {
            OptionCaption = ',ok,not ok, not applicable';
            OptionMembers = ,ok,"not ok"," not applicable";
        }
        field(68082;"Card Reader";Option)
        {
            OptionCaption = ',ok,not ok, not applicable';
            OptionMembers = ,ok,"not ok"," not applicable";
        }
        field(68083;"ATM Room Cleanliness";Option)
        {
            OptionCaption = ',Dirty,Average,Clean';
            OptionMembers = ,Dirty,"Average",Clean;
        }
        field(68084;"Note Quality";Option)
        {
            OptionCaption = ',Old,Serviceable,New';
            OptionMembers = ,Old,Serviceable,New;
        }
        field(68085;"cause of error";Text[50])
        {
        }
        field(68086;Email;Text[50])
        {
        }
        field(68087;"bank abbre";Code[30])
        {
        }
        field(68088;"manager ID";Code[20])
        {

            trigger OnValidate()
            begin
                if atmregister.Get("ATM No") then begin
                "manager ID":=atmregister."Manager ID";
                HREngineers.SetRange(HREngineers."No.","manager ID");
                if HREngineers.Find('-') then begin
                "manager Email":=HREngineers."E-Mail";
                end;
                end;
            end;
        }
        field(68089;"manager Email";Text[50])
        {
        }
        field(68090;"mail send";Boolean)
        {
        }
        field(68091;"send mail";Option)
        {
            OptionCaption = ',yes,no';
            OptionMembers = ,yes,no;
        }
        field(68092;"Case Category";Code[30])
        {
            TableRelation = "Atm Case Categories"."category Code";
        }
        field(68093;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(68094;"Date resource assigned";Date)
        {
        }
        field(68095;"resolved by id";Code[15])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                hreng.Reset;
                hreng.SetRange(hreng."No.","resolved by id");
                if hreng.FindFirst() then begin
                     "resolved by Name":=hreng."Full Name";

                end;
                
            end;
        }
        field(68096;"resolved by Name";Text[50])
        {
        }
        field(68097;Invoice;Blob)
        {
            SubType = Bitmap;
        }
        field(68098;"Engineer ID";Blob)
        {
            SubType = Bitmap;
        }
        field(68099;"Assigned No";Code[20])
        {
        }
        field(68100;"Entry No";Integer)
        {
            AutoIncrement = false;
        }
        field(68101;Flag;Boolean)
        {
        }
        field(68102;EmpId;Code[10])
        {
        }
        field(68103;"Employee No";Code[20])
        {
        }
        field(68104;"Reason for Involuntary closure";Text[100])
        {
        }
        field(68105;"Bank Signature";Text[50])
        {
        }
        field(68106;Diagnosis;Text[200])
        {
        }
        field(68107;"Under observation";Boolean)
        {
        }
        field(68108;"PM Done";Boolean)
        {
        }
        field(68109;"Case Photo";Media)
        {
            Caption = 'Case Photo';
        }
        field(68110;"Case Image";Media)
        {
            Caption = 'Image';
            ExtendedDatatype = Person;
        }
    }

    keys
    {
        key(Key1;"Resource Assigned","Case Number")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //GENERATE NEW NUMBER FOR THE DOCUMENT
        if "Case Number" = '' then begin
          HRSetup.Get;
          HRSetup.TestField(HRSetup."Cases nos");
          "Case Number":=NoSeriesMgt.GetNextNo(HRSetup."Cases nos",today,true);
        end;
        "Case Received  Date":=Today;
    end;

    trigger OnModify()
    begin
                  if Status=Status::Resolved then
                   Error('You cannot modify a closed case');

    end;

    var
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        casem: Record "Cases Management.";
        casen: Record "Cases Management.";
        CPeriod: Integer;
        currYear: Integer;
        StartDate: Date;
        EndDate: Date;
        Month: Integer;
        DAY: Integer;
        HREngineers: Record "HR-Employee";
        AtmObject: Record "ATM Requestion Register";
        atmregister: Record "ATM Register.";
        atmgenenq: Record "ATM General Enquiries";
        hreng: Record "HR-Employee";
}

