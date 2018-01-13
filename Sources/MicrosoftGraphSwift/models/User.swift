import Foundation

//Main User Object
open class User: Codable{
    public var id: String?
    public var accountEnabled: Bool?
    public var birthday: Date?
    public var city: String?
    public var companyName: String?
    public var country: String?
    public var department: String?
    public var displayName: String?
    public var givenName: String?
    public var hireDate: Date?
    public var jobTitle: String?
    public var mail: String?
    public var mailNickname: String?
    public var mobilePhone: String?
    public var postalCode: String?
    public var preferredName: String?
    public var schools: [String]?
    public var state: String?
    public var streetAddress: String?
    public var surName: String?
    public var userPrincipalName: String?
    public var userType: String?
    public var odataType: String?
    public var passwordProfile: UserPassword?
    
    ///tried to access string values below to create url
    public enum CodingKeys: String, CodingKey {
        case id
        case accountEnabled
        case birthday = "birthday"
        case city
        case companyName
        case country
        case department
        case displayName = "displayName"
        case givenName
        case hireDate
        case jobTitle
        case mail
        case mailNickname
        case mobilePhone
        case postalCode
        case preferredName
        case schools
        case state
        case streetAddress
        case surName = "surname"
        case userPrincipalName
        case userType
        case odataType = "@odata.type"
        case passwordProfile
    }
    
    public init(
        id: String? = nil,
        accountEnabled: Bool? = nil,
        birthday: Date? = nil,
        city: String? = nil,
        companyName: String? = nil,
        country: String? = nil,
        department: String? = nil,
        displayName: String? = nil,
        givenName: String? = nil,
        hireDate: Date? = nil,
        jobTitle: String? = nil,
        mail: String? = nil,
        mailNickname: String? = nil,
        mobilePhone: String? = nil,
        postalCode: String? = nil,
        preferredName: String? = nil,
        schools: [String]? = nil,
        state: String? = nil,
        streetAddress: String? = nil,
        surName: String? = nil,
        userPrincipalName: String? = nil,
        userType: String? = nil,
        odataType: String? = nil,
        passwordProfile: UserPassword? = nil
        ){
        self.id = id
        self.accountEnabled = accountEnabled
        self.birthday = birthday
        self.city = city
        self.companyName = companyName
        self.country = country
        self.department = department
        self.displayName = displayName
        self.givenName = givenName
        self.hireDate = hireDate
        self.jobTitle = jobTitle
        self.mail = mail
        self.mailNickname = mailNickname
        self.mobilePhone = mobilePhone
        self.postalCode = postalCode
        self.preferredName = preferredName
        self.schools = schools
        self.state = state
        self.streetAddress = streetAddress
        self.surName = surName
        self.userPrincipalName = userPrincipalName
        self.userType = userType
        self.odataType = odataType
        self.passwordProfile = passwordProfile
    }
    
}

//Password Profile Setting when creating user
public struct UserPassword: Codable{
    public var forceChangePasswordNextSignIn: Bool?
    public var password: String?
    enum CodingKeys: String, CodingKey{
        case forceChangePasswordNextSignIn
        case password
    }
    
    public init(forceChangePasswordNextSignIn: Bool?, password: String?){
        self.forceChangePasswordNextSignIn = forceChangePasswordNextSignIn
        self.password = password
    }
}



