Table 50445 "Investigator Information"
{

    fields
    {
        field(1; "Code"; Code[10])
        {

            trigger OnValidate()
            begin

                if Code <> xRec.Code then begin
                    JobSetup.Get;
                    NoSeriesMgt.TestManual(JobSetup."Donor Contact Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Project Title"; Text[100])
        {
            CalcFormula = lookup(Jobs.Title where("No." = field("Job No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "PI Name"; Text[30])
        {
            CalcFormula = lookup(Jobs."Principal Investigator name" where("No." = field("Job No.")));
            Caption = 'Principal Investigator Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "PI Pri Inst Affiliation"; Code[10])
        {
            Caption = 'Principal Investigator Institution Affiliation';
            Editable = false;
            FieldClass = Normal;
        }
        field(5; "PI Postal Address"; Text[30])
        {
            CalcFormula = lookup(Jobs."Bill-to Address" where("No." = field("Job No.")));
            Caption = 'Principal Investigator Postal Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "PI Telephone"; Text[30])
        {
            Caption = 'Principal InvestigatorTelephone';
            FieldClass = Normal;
        }
        field(7; "PI FAX"; Text[30])
        {
            Caption = 'Principal Investigator FAX';
        }
        field(8; "PI Email"; Text[30])
        {
            CalcFormula = lookup(Jobs."Bill-to Address 2" where("No." = field("Job No.")));
            Caption = 'Principal Investigator Email';
            FieldClass = FlowField;
        }
        field(9; "CPI Name"; Text[30])
        {
            CalcFormula = lookup(Jobs."PI Name" where("No." = field("Job No.")));
            Caption = 'Co. Principal Investigator Name';
            FieldClass = FlowField;
        }
        field(10; "CPI Pri Inst Affiliation"; Text[30])
        {
            Caption = 'Co. Principal Investigator Institution Affiliation';
        }
        field(11; "CPI Postal Address"; Text[30])
        {
            CalcFormula = lookup(Jobs."PI Address" where("No." = field("Job No.")));
            Caption = 'Co. Principal Investigator Postal Address';
            FieldClass = FlowField;
        }
        field(12; "CPI Telephone"; Text[30])
        {
            CalcFormula = lookup(Jobs."PI Telephone" where("No." = field("Job No.")));
            Caption = 'Co. Principal InvestigatorTelephone';
            FieldClass = FlowField;
        }
        field(13; "CPI FAX"; Text[30])
        {
            Caption = 'Co. Principal Investigator FAX';
        }
        field(14; "CPI Email"; Text[30])
        {
            CalcFormula = lookup(Jobs."PI EMail" where("No." = field("Job No.")));
            Caption = 'Co. Principal Investigator Email';
            FieldClass = FlowField;
        }
        field(15; "Ampath Consortium Collaborator"; Option)
        {
            Caption = 'Need assistance to identify Collaborator?';
            OptionMembers = Pending,Yes,No;
        }
        field(16; "Study Type"; Option)
        {
            Caption = 'Study type will be a:';
            OptionMembers = " ","Retrospective Cohort","Prospective Cohort","Clinical Trial",Other;
        }
        field(17; "Primary Objectives"; Text[250])
        {
            Caption = 'List primary objectives';
        }
        field(18; "Project Description"; Text[250])
        {
            Caption = 'Provide project description';
        }
        field(19; Funding; Option)
        {
            Caption = 'Seeking funding for project?';
            OptionMembers = Pending,Yes,No;
        }
        field(20; Attachment; Boolean)
        {
            Caption = 'Project Attached';
        }
        field(21; "Support Description"; Text[30])
        {
            Caption = 'If no, how will project be supported';
        }
        field(22; "Funding Application Deadline"; Date) { }
        field(23; "Res. & Working Approval"; Option)
        {
            Caption = 'Received research working group approval?';
            OptionMembers = Pending,Yes,No;
        }
        field(24; "Ampath Data Anlsys Team App"; Option)
        {
            Caption = 'Received Ampath Data analysis approval?';
            OptionMembers = Pending,Yes,No;
        }
        field(25; "IREC Approval"; Option)
        {
            Caption = 'Received IREC approval?';
            OptionMembers = Pending,Yes,No;
        }
        field(26; "EIPL Approval"; Option)
        {
            Caption = 'Received Export/Import Permits for Laboratory Specimens?';
            OptionMembers = Pending,Yes,No;
        }
        field(27; "Job No."; Code[10]) { }
        field(28; "LTA Test  Known"; Option)
        {
            Caption = 'Lab testing algorithm known';
            OptionMembers = " ",No,Yes;
        }
        field(29; "LTA Proposal Submission"; Option)
        {
            Caption = 'Algorithm included with this proposal submission';
            OptionMembers = " ",No,Yes;
        }
        field(30; "LTA Description"; Text[250])
        {
            Caption = 'Describe proposed testing schedule';
        }
        field(31; "Covered Tests"; Option)
        {
            Caption = 'Are all test lists covered by current test list?';
            OptionMembers = " ",No,Yes;
        }
        field(32; "SPR study"; Option)
        {
            Caption = 'Special processing requirements required?';
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ",No,Yes;
        }
        field(33; "SPR Description"; Text[250])
        {
            Caption = 'Describe special processing required';
        }
        field(34; "Sample Storage Requirements"; Option)
        {
            Caption = 'Special storage requirements for samples?';
            OptionMembers = " ",No,Yes;
        }
        field(35; "SSR Destruction prot"; Option)
        {
            Caption = 'Special protocol required for sample destruction?';
            OptionMembers = " ",No,Yes;
        }
        field(36; "SSR Shipment?"; Option)
        {
            Caption = 'Do samples need to be shipped?';
            OptionMembers = " ",No,Yes;
        }
        field(37; "SSR Description"; Text[250])
        {
            Caption = 'Describe above special requirements';
        }
        field(38; "Data Storage Requirements"; Option)
        {
            Caption = 'Special data storage requirements?';
            OptionMembers = " ",No,Yes;
        }
        field(39; "DSR Description"; Text[250])
        {
            Caption = 'Describe special data storage requirements';
        }
        field(40; "Special Requirements"; Option)
        {
            Caption = 'Special Requirements for laboratory staff?';
            OptionMembers = " ",No,Yes;
        }
        field(41; "Odd Working Hours"; Option)
        {
            Caption = 'Is there need for extended working hours';
            OptionMembers = " ",No,Yes;
        }
        field(42; "Odd working hours description"; Text[250])
        {
            Caption = 'Describe above';
        }
        field(43; "Study Population"; Text[250])
        {
            Caption = 'Describe study population yoiu plan to work with';
            Description = 'For biostatistics information going forward';
        }
        field(44; "Sampling methods"; Text[250])
        {
            Caption = 'Describe proposed sampling methods';
        }
        field(45; "Dependent Variables"; Text[250])
        {
            Caption = 'Describe dependent variables for this study';
        }
        field(46; "Independent Variables"; Text[250])
        {
            Caption = 'Describe independent variables included';
        }
        field(47; "Project Statistician Name"; Text[100])
        {
            Caption = 'Project Statistician Name';
        }
        field(48; "PS Primary Inst. Affiliation"; Text[30])
        {
            Caption = 'Project statistician primary institution affiliation';
        }
        field(49; "PS Address"; Text[30])
        {
            Caption = 'Project statistician address';
        }
        field(50; Telephone; Integer)
        {
            Caption = 'Project statistician telephone';
        }
        field(51; "No. Series"; Code[20]) { }
        field(52; "PS Fax"; Text[30]) { }
        field(53; "PS Email"; Text[30]) { }
        field(54; SampleStorgePeriod; Text[50])
        {
            Caption = 'How long do samples need to be stored?';
        }
        field(55; PSTelephone; Text[30])
        {
            Caption = 'Project Statistician Telephone';
        }
        field(56; "Staff Specification"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Code", "Job No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if Code = '' then begin
            JobSetup.Reset;
            JobSetup.Get();
            JobSetup.TestField(JobSetup."Donor Contact Nos");
           Code:= NoSeriesMgt.GetNextNo(JobSetup."Donor Contact Nos", Today, true);
        end;
    end;

    var
        JobSetup: Record "Jobs-Setup";
        NoSeriesMgt: Codeunit "No. Series";
}

