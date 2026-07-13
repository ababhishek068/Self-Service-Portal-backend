table 50184 "Registration Form"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Serial No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(100; "Service Number"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Full Names"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Gender"; option)
        {
            OptionMembers = " ",Male,Female;
            DataClassification = ToBeClassified;

        }
        field(4; "Training College"; code[20])
        {
            DataClassification = ToBeClassified;
            tablerelation = "Training Colleges".Code;
        }
        field(5; "Brigade"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Brigade.Code where("Paramilitary Academy" = field("Paramilitary Academy"));
        }
        field(6; "Region"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Region.code;

        }
        field(7; "Tribe"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Tribe"."Sub Tribe Code";
        }
        field(8; "Date of Enlistment"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Exit Mode"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Exit Modes".Code;

        }
        field(10; "Mean Grade"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Mean Grade".Code;

        }
        field(11; "Letter No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(12; "ID Number"; code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if Strlen("ID Number") > 8 then
                    error('The National ID should not be more than eight characters');
            end;
        }
        field(112; "Huduma Number"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Is Disable"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(113; "Type of Disability"; text[300])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestField("Is Disable", true);
            end;
        }
        field(14; "Date Of Birth"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(15; "Barrack"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Barracks".Code where("Paramilitary Academy" = field("Paramilitary Academy"), Brigate = field(Brigade));

        }
        field(16; "Sub Region"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Region".code where(Region = field(Region));

        }
        field(17; "Recruitment Center"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Recruitment Centers".Code where("Sub Region" = field("Sub Region"));
        }
        field(18; "NBU"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = NBU.Code;

        }
        field(19; "Date of Exit"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(20; "Completion Year"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(21; "Denomination"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Religions;
        }
        field(22; "Nearest Village"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(712; "Talent"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(122; "Location/Sublocation"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(23; "Chief's Name"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(24; "Chief's Contact"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(25; "Assist. Chief Name"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(26; "Assist. Chief Contact"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(125; "Village Elder Name"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(126; "Village Elder Contact"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(27; "Nearest Police Station"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(28; "Nearest Town"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(29; "Father's Name"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(30; "Father's Contacts"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(31; "Father Alive/Deceased"; Option)
        {
            OptionMembers = Alive,Deceased;
            DataClassification = ToBeClassified;

        }
        field(32; "Mother's Name"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(33; "Mother's Contact"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(34; "Mother Alive/Deceased"; Option)
        {
            OptionMembers = Alive,Deceased;
            DataClassification = ToBeClassified;

        }
        field(35; "Gurdian's Name"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(36; "Gurdian's Contact"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(37; "Status"; Option)
        {
            OptionMembers = Pending,Confirmed,"Service",TVET,Exited;
            DataClassification = ToBeClassified;

        }
        field(38; "Bank Name"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(39; "Bank Branch Name"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(40; "Bank Account No"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(61; "Applicant Photo"; Media)
        {
            DataClassification = ToBeClassified;
        }
        field(62; "First Choice Programme"; Code[20])
        {

            TableRelation = "Programme".Code;
        }
        field(63; "Second Choice Programme"; Code[20])
        {

            TableRelation = "Programme".Code;
        }
        field(64; "Third Choice Programme"; Code[20])
        {

            TableRelation = "Programme".Code;
        }
        field(65; "Approved Programme"; Code[20])
        {

            TableRelation = "Programme".Code;
        }
        field(66; "Current Station"; Code[20])
        {
            TableRelation = "Service Units".code;
        }
        field(67; "Current Main Duty"; Code[20])
        {
            TableRelation = "Service Duties".code;
        }
        field(68; "Current Sub Duty"; Code[20])
        {
            TableRelation = "Service Sub Duties".code;
        }

        field(69; "Date Confirmed"; date) { }
        field(70; "Confirmed By"; Code[20]) { }
        field(71; "No. Series"; Code[20]) { }
        field(72; "Discharge Reason"; Code[20]) { }
        field(272; "Reason for Enrollment"; Code[20]) { }

        field(172; "User ID"; Code[30]) { }
        field(173; "Next of Kin Name"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(174; "Next of Kin Contact"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(175; "Boot Size"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(176; "Reporting Institution"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(177; "Paramilitary Academy"; Code[20])
        {
            TableRelation = "Paramilitary Academy".Code;
        }
        field(178; "Other Qualification"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(179; "Cohort"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Intake.Code where(Current = filter(true));
        }
        field(180; "Current Cohort"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Intake.Current where(Code = field(Cohort), Current = const(true)));
        }
        field(181; Rank; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Ranks.Code;
        }
        field(182; "Staff No"; Code[30])
        {
            TableRelation = "HR-Employee"."No.";
        }
    }

    keys
    {
        key(Key1; "Serial No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        GenLedgerSetup: Record "NYS Service Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin

        if "Serial No" = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Serial Nos");
            "Serial No" := NoSeriesMgt.GetNextNo(GenLedgerSetup."Serial Nos", 0D, true);
            "User ID" := Database.UserId;
        end;
        "Date of Enlistment" := Today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        if Status <> Status::Pending then error('Please note that you can not delete a confirmed registration');
    end;

    trigger OnRename()
    begin

    end;

}