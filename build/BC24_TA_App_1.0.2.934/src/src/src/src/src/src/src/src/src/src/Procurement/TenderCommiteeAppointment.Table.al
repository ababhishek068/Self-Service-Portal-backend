#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50003 "Tender Commitee Appointment"
{
    

    fields
    {
        field(1;"Tender/Quotation No";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Quote Header"."No." where("Document Type"=const("Open Tender"));

            trigger OnValidate()
            begin
                 if TenderRec.Get("Tender/Quotation No") then
                  begin
                  Title:=TenderRec."Request Description";
                  end;
            end;
        }
        field(2;"Committee ID";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Procurement Commitee";

            trigger OnValidate()
            begin
                  if ProcurementComittee.Get("Committee ID") then
                  begin
                     "Committee Name":=ProcurementComittee.Description;

                  end;
            end;
        }
        field(3;"Committee Name";Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4;"Creation Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5;"User ID";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6;Title;Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7;"Appointment No";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8;"No. Series";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(9;Status;Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(50000;"Deadline For Report Submission";Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Appointment No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Status, Status::Open);
    end;

    trigger OnInsert()
    begin
        PurchSetup.Get;
        PurchSetup.TestField(PurchSetup."Appointment Nos.");
        //NoSeriesMgt.InitSeries(,xRec."No. Series",0D,"Appointment No","No. Series");
        "Appointment No":=NoSeriesMgt.GetNextNo(PurchSetup."Appointment Nos.",0D,true);


        "Creation Date":=Today;
        "User ID":=UserId;
    end;

    var
        ProcurementComittee: Record "Procurement Commitee";
        TenderRec: Record "Purchase Quote Header";
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

