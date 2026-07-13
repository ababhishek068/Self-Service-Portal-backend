TableExtension 50007 tableextension70134675 extends Vendor
{

    //Unsupported feature: Property Modification (Permissions) on "Vendor(Table 23)".

    LookupPageID = "Vendor List";
    DrillDownPageId = "Vendor List";
    fields
    {
        field(50145; "Vendor Credit Limit(LCY)"; Decimal) { }
        field(50146; "Requisition Default Vendor"; Boolean) { }
        field(50147; "Vendor Retention Account"; Code[20])
        {
            TableRelation = Vendor."No." where(Retention = const(true));
        }
        field(50148; Retention; Boolean) { }
        field(50149; "TIN No."; Code[20]) { }
        field(50150; "Vendor Bank Account"; Code[20]) { }
        field(50151; "Vendor Bank Branch Code"; Code[20]) { }
        field(52500; "AGPO No"; Code[50]) { }
        field(39005580; "Vendor Type"; Option)
        {
            OptionCaption = ' ,Implementing Partner,Goods,Services,Contract,Goods & Services,Council,Staff';
            OptionMembers = " ","Implementing Partner",Goods,Services,Contract,"Goods & Services",Council,Staff;

            trigger OnValidate()
            begin

                //Prevent Changing once entries exist
                // TestNoEntriesExist(FieldCaption("Vendor Type"));
            end;
        }
        field(39005581; "Property Code"; Code[30])
        {
            TableRelation = "Request For Qoute Line"."Line No";
        }
        field(39005582; "Transaction Code"; Code[30])
        {
            TableRelation = "Menu Sales Line"."Line No";
        }
        field(39005583; "Employee Responsible"; Code[30]) { }
        field(39005584; "Landlord No."; Code[10])
        {

            trigger OnValidate()
            begin
                /*//generates Landlords No(for property)
                IF "Landlord No." <> xRec."Landlord No." THEN BEGIN
                  GenSetup.GET;
                  NoSeriesMgt.TestManual(GenSetup."Landlord Nos.");
                  "No. Series" := '';
                END;
                 */

            end;
        }
        field(39005585; No2; Code[20]) { }
        field(39005586; "No. of Vendor Cateories"; Integer)
        {
            Editable = false;

        }
        field(39005587; "Main Sub/Sub"; Option)
        {
            Caption = 'Main Sub/Sub';
            Editable = false;
            OptionCaption = ' ,Main Sub,Sub';
            OptionMembers = " ","Main Sub",Sub;
        }
        field(39005588; Sub; Code[20])
        {
            Caption = 'Sub Of Sub';
            Editable = false;
            TableRelation = Vendor;
        }
        field(39005589; "Compliance Passed"; Boolean) { }
        field(50100; "Vendor Category"; code[20])
        {
            TableRelation = "Supplier Category".Code;
        }
        field(50101; "Agpo Category"; code[20])
        {
            TableRelation = "AGPO Category";
        }
        field(50102; Gender; Option)
        {
            OptionMembers = ,Male,Female;
        }
        field(50103; "Agpo Cert. Date"; date) { }
        field(50104; "Vendor Eligibilty"; code[20])
        {
            TableRelation = "Vendor Eligibility".code;
        }

        field(50105; Trainer; Boolean) { }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on "Blocked(Key)".

    }
    procedure TestNoEntriesExist(CurrentFieldName: Text[100])
    var
        ItemLedgEntry: Record "Vendor Ledger Entry";
    begin
        ItemLedgEntry.SetCurrentkey("Vendor No.");
        ItemLedgEntry.SetRange("Vendor No.", "No.");
        if ItemLedgEntry.Find('-') then
            Error(
              Text012,
              CurrentFieldName);
    end;

    //Unsupported feature: Deletion (VariableCollection) on "ShowContact(PROCEDURE 1).ConfirmManagement(Variable 1004)".


    //Unsupported feature: Property Modification (Length) on "GetVendorNo(PROCEDURE 19).VendorText(Parameter 1000)".


    //Unsupported feature: Property Modification (Length) on "GetVendorNoOpenCard(PROCEDURE 56).VendorText(Parameter 1000)".


    //Unsupported feature: Property Modification (Length) on "CreateNewVendor(PROCEDURE 59).VendorName(Parameter 1000)".


    //Unsupported feature: Deletion (VariableCollection) on "IsContactUpdateNeeded(PROCEDURE 48).VendContUpdate(Variable 1001)".


    //Unsupported feature: Property Modification (Length) on "SetAddress(PROCEDURE 40).VendorAddress(Parameter 1001)".


    //Unsupported feature: Property Modification (Length) on "SetAddress(PROCEDURE 40).VendorContact(Parameter 1006)".


    var
        Text012: label 'You cannot change the contents of the %1 field because this %2 has one or more posted ledger entries.';
}

