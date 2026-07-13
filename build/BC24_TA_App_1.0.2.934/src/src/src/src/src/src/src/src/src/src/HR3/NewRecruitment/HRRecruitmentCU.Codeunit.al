codeunit 50033 "HR Recruitment CU"
{

    trigger OnRun();
    begin
    end;

    var
        HRMSApplicantRegister: Record "HRMS Applicant Register";

        HRMSApplicantQualification: Record "HRMS Applicant Qualifications";

    /*
    HRMSApplicantRegister: Record "50021";
    TbApplicantDocs: Record "50035";
    TbApplicantReferees: Record "50043";
    TbHRApplicantHobbies: Record "50026";
    TbHREmployeeRequisitions: Record "50018";
    TbHRJobApplications: Record "50022";
    TbHRApplicantQualifications: Record "50045";
    TbApplicantEducationBackground: Record "50033";
    TbApplicantEmploymentProfile: Record "50038";
    TbHRApplicantReferees: Record "50025";
    TbHREmplRequisitions: Record "50018";
    TbHREmploymentHistory: Record "50020";
    TbHRAppEmploymentDetails: Record "50041";
    TbApplicantEmploymentDetails: Record "50039";
    TbApplicantRelevantDocuments: Record "50042";
    TbHRLookupValues: Record "70135124";
    TbApplicantHobbies: Record "50044";
    TbHRJobRequirements: Record "50016";
    TbHRJobInterviewTable: Record "50028";
    TbApplicantProfiles: Record "50036";
    TbHRJobQualifications: Record "50023";
    
    */
    procedure fn_RegisterApplicant(email: Text[150]; password: Text[150]; idno: Text[150]; fname: Text[100]; mname: Text[100]; lname: Text[100]; randomValue: Text) return: Boolean;
    begin
        return := FALSE;
        HRMSApplicantRegister.RESET;
        HRMSApplicantRegister.SETRANGE(HRMSApplicantRegister."E-Mail", email);
        IF not HRMSApplicantRegister.FINDFIRST() THEN BEGIN

            HRMSApplicantRegister."E-Mail" := email;
            HRMSApplicantRegister.Password := password;
            HRMSApplicantRegister."ID Number" := idno;
            HRMSApplicantRegister."First Name" := fname;
            HRMSApplicantRegister."Middle Name" := mname;
            HRMSApplicantRegister."Last Name" := lname;
            HRMSApplicantRegister."Verification Token" := randomValue;
            HRMSApplicantRegister.Insert();
            return := TRUE;
        END ELSE BEGIN
            Error('The email address [ %1 ] is already registered in the system', email);
        END;
        EXIT(return);
    end;

    procedure UpdateApplicantProfile(userName: Code[100]; emailAddress: Text[100]; firstName: Text[100]; middleName: Text[100]; lastName: Text[100]; title: Text[20]; idNumber: Text; passportNumber: Text[100]; gender: Integer; maritalStatus: Integer; ethnicity: Code[20]; dateofBirth: Date; disability: Boolean; postalAddress: Text[100]; postalCode: Text[100]; postalTown: Text[100]; Region: Text[100]; phoneNumber: Text[100]; disabilityDesc: Text[200]; country: Code[50]; firstLanguage: Code[50]; secondLanguage: Code[50]) return_value: Boolean;
    begin
        return_value := FALSE;
        HRMSApplicantRegister.RESET;

        HRMSApplicantRegister.SETRANGE("E-Mail", emailAddress);
        IF HRMSApplicantRegister.FINDFIRST() THEN BEGIN

            HRMSApplicantRegister."E-Mail" := emailAddress;
            HRMSApplicantRegister."First Name" := firstName;
            HRMSApplicantRegister."Middle Name" := middleName;
            HRMSApplicantRegister."Last Name" := lastName;

            HRMSApplicantRegister."ID Number" := idNumber;
            HRMSApplicantRegister."Passport Number" := passportNumber;
            HRMSApplicantRegister.Gender := gender;
            HRMSApplicantRegister."Marital Status" := maritalStatus;
            HRMSApplicantRegister.Ethnicity := ethnicity;
            HRMSApplicantRegister."Date Of Birth" := dateofBirth;
            HRMSApplicantRegister.Disabled := disability;
            HRMSApplicantRegister."Disability Details" := disabilityDesc;
            HRMSApplicantRegister."Postal Address" := postalAddress;


            HRMSApplicantRegister.Region := Region;
            HRMSApplicantRegister.Nationality := country;

            HRMSApplicantRegister."Phone Number" := phoneNumber;

            HRMSApplicantRegister.MODIFY;
            return_value := TRUE;
        END
        ELSE BEGIN
            Error('The email address [ %1 ] is does not exist', emailAddress);
        END;
    end;

    procedure fn_AddQualification(Qualtype: Code[20]; QualCategory: code[20]; QualCode: code[20]; institution: Text[250]; fromWhen: Date; toWhen: Date; grade: Text[250]; emailAddress: Code[100]) return_value: Boolean;
    var
        lineNo: Integer;
    begin
        return_value := FALSE;
        HRMSApplicantQualification.RESET;
        IF HRMSApplicantQualification.FINDLAST() THEN BEGIN
            lineNo := HRMSApplicantQualification."Line No." + 1
        END ELSE BEGIN
            lineNo := 0;
        END;

        HRMSApplicantQualification.INIT();
        HRMSApplicantQualification.Email := emailAddress;

        HRMSApplicantQualification."Line No." := lineNo;
        HRMSApplicantQualification."Qualification Category" := QualCategory;
        HRMSApplicantQualification."Qualification Type" := Qualtype;
        HRMSApplicantQualification."Qualifcation Code" := QualCode;
        HRMSApplicantQualification.Validate("Qualifcation Code");

        HRMSApplicantQualification."Institution" := institution;
        HRMSApplicantQualification."From Date" := fromWhen;
        HRMSApplicantQualification."To Date" := toWhen;
        HRMSApplicantQualification.INSERT;
        return_value := TRUE;
    end;

    procedure fn_deleteQualification(lineNo: Integer; emailAddress: Text[100]) return_value: Boolean;
    begin
        return_value := FALSE;
        HRMSApplicantQualification.RESET;
        HRMSApplicantQualification.SETRANGE(HRMSApplicantQualification."Line No.", lineNo);
        HRMSApplicantQualification.SETRANGE(HRMSApplicantQualification.Email, emailAddress);
        HRMSApplicantQualification.DELETE();
        return_value := TRUE;
    end;
}

