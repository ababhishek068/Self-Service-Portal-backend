Table 50552 "Disposal Plan Table Header"
{

    fields
    {
        field(1; "No."; Code[10])
        {

            trigger OnValidate()
            begin

                if "No." <> xRec."No." then begin
                    GetInvtsetup;
                    NoSeriesMgt.TestManual(Invtsetup."Item Nos.");
                    "No. Series" := '';

                end;
            end;
        }
        field(2; Year; Date) { }
        field(3; Description; Text[30]) { }
        field(4; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));


        }
        field(5; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));


        }

        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));


        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));


        }

        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Disposal Method"; Code[20])
        {
            TableRelation = "Disposal Methods"."Disposal Methods";

            trigger OnValidate()
            begin
                dispoline.Reset;
                dispoline.SetRange(dispoline."Ref. No.", "No.");
                if dispoline.Find('-') then begin
                    dispoline."Disposal Method" := "Disposal Method";
                    dispoline.Modify;
                end;
            end;
        }
        field(50000; "Disposal Methodc"; Option)
        {
            OptionCaption = ' ,Open tender,public auction,Trade-in,Transfer,Dumping';
            OptionMembers = " ","Open tender","public auction","Trade-in",Transfer,Dumping;
        }
        field(50001; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Posted';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Posted;
        }
        field(50002; "Disposal Status"; Option)
        {
            OptionMembers = " User Department",Procurement,"Disposal Committee","Director General";
        }
        field(50003; Date; Date) { }
        field(50004; "No series"; Code[20]) { }
        field(50005; "Ref No"; Code[30]) { }
        field(50006; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center BR".Code;
        }
        field(50007; "Planned Date"; Date) { }
        field(50009; "Disposal Year"; Code[20])
        {
            NotBlank = false;
            TableRelation = "Disposal Period".Code;

            trigger OnValidate()
            begin
                DisposalPeriod.Reset;
                DisposalPeriod.SetRange(DisposalPeriod.Code, "Disposal Year");
                if DisposalPeriod.Find('-') then
                    "Disposal Description" := DisposalPeriod.Description;
            end;
        }
        field(50010; "Disposal Description"; Text[30]) { }
        field(50011; "Date of Purchase"; Date) { }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Ref No") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin

        //GENERATE NEW NUMBER FOR THE DOCUMENT
        if "No." = '' then begin
            PurchSetup.Get;
            PurchSetup.TestField(PurchSetup."Disposal Plan No.");
            "No.":=NoSeriesMgt.GetNextNo(PurchSetup."Disposal Plan No.",  0D, true);
        end;
    end;

    var
        Invtsetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
        PurchSetup: Record "Purchases & Payables Setup";
        DisposalPeriod: Record "Disposal Period";
        dispoline: Record "Disposal plan table lines";

    procedure GetInvtsetup()
    begin
    end;
}

