Table 50509 "Tender Plan Header"
{
    fields
    {
        field(1; "No."; code[20])

        {
            NotBlank = true;
            // OptionCaption = 'Quotation Request,Open Tender,Restricted Tender,Low Value Procurement,Direct Procurement,Request for Proposal,EOI';
            // OptionMembers = "Quotation Request","Open Tender","Restricted Tender","Low Value Procurement","Direct Procurement","Request for Proposal",EOI;
        }
        field(2; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Published,Closed';
            OptionMembers = Open,Published,Closed;
        }
        field(3; "Workplan Code"; Code[20])
        {
            Description = 'Workplan Code';
            TableRelation = "Workplan Activities"."Activity Code" WHERE("Shortcut Dimension 2 Code" = FIELD("Department Code"));

            trigger OnValidate()
            begin
                // IF "Workplan code" = '' THEN BEGIN

                Workplan.RESET;
                IF Workplan.GET("Workplan Code") THEN BEGIN
                    "Workplan Description" := Workplan."Activity Description";
                END ELSE BEGIN
                    MESSAGE('not found');
                END;
                // MODIFY
            end;
        }
        field(4; "Publishing Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Publishing Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Closing Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Closing Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Tender Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',General,Services,Works,Goods';
            OptionMembers = ,General,Services,Works,Goods;
        }
        field(9; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(10; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(11; "Procurement Method";Option)
        {   

             OptionCaption = 'Quotation Request,Open Tender,Restricted Tender,Low Value Procurement,Direct Procurement,Request for Proposal,EOI';
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender","Low Value Procurement","Direct Procurement","Request for Proposal",EOI;
            TableRelation = "Procurement Methods".Code;

            trigger OnValidate()
            begin

                CLEAR("Procurement Method Name");

                Procumethod.RESET;
                IF Procumethod.GET("Procurement Method") THEN "Procurement Method Name" := Procumethod.Description;


                TendStages.RESET();
                TendStages.SETRANGE("Tender No.", "No.");
                IF NOT TendStages.ISEMPTY() THEN TendStages.DELETEALL();


                ProcStages.RESET();
                ProcStages.SETRANGE(ProcStages."Proc. Method No.", "Procurement Method");


                PrevStageDate := "Start Date";
                IF ProcStages.FIND('-') THEN
                    REPEAT
                        TendStages.INIT;
                        TendStages."Tender No." := "No.";
                        TendStages.Description := ProcStages.Description;
                        TendStages.Stage := ProcStages.Stage;
                        TendStages."Sorting No." := ProcStages."Sorting No.";
                        //TendStages."WorkPlan Code":="Workplan Code";
                        TendStages."Planned start date" := PrevStageDate;
                        //TendStages."Planned end date":=CALCDATE('+'+FORMAT(TendStages."Planned duration")+'D',TendStages."Planned start date");
                        PrevStageDate := TendStages."Planned end date";
                        TendStages.INSERT;
                    UNTIL ProcStages.NEXT = 0;
            end;
        }
        field(12; "Start Date"; Date) { }
        field(13; "Workplan Description"; Text[250])
        {
            Editable = false;
            TableRelation = "Workplan Entry"."Workplan Code";
        }
        field(14; "Procurement Method Name"; Text[50])
        {
            Editable = false;
        }
        field(15; "No. Series"; Code[20]) { }
        field(16; Category; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Services,Consumables,General';
            OptionMembers = ,Services,Consumables,General;
        }
        field(17; "Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Last Modified By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "First User"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No." WHERE(Status = FILTER(Active));
        }
        field(20; "Second User"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No." WHERE(Status = FILTER(Active));
        }
        field(21; "Third User"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No." WHERE(Status = FILTER(Active));
        }
        field(22; "Tender Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Cancelled';
            OptionMembers = Open,"Pending Approval",Approved,Cancelled;
        }
        field(24; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
        }
        field(26; "Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
        }
        field(27; Addendum; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Tender Category"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Supplier Portal Central Setups".Code where(Type = filter("Tender Category"));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        TendStages.RESET;
        TendStages.SETRANGE(TendStages."Tender No.", "No.");
        IF TendStages.FIND('-') THEN BEGIN
            TendStages.DELETEALL(TRUE);
        END;
    end;

    trigger OnModify()
    begin
        //IF Status <> Status::Published THEN ERROR('You cannot modify this tender when status is closed or published');
    end;

    var
        TendStages: Record "Tender Plan Lines";
        PrevStageDate: Date;
        Workplan: Record "Workplan Activities";
        Procumethod: Record "Procurement Methods";
        ProcStages: Record "Proc. Method Stage Duration";
}

