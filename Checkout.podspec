Pod::Spec.new do |s|
  s.name                = "Checkout"
  s.version             = "1.0.0"
  s.summary             = "Utility library for accepting credit card payments."
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage            = "https://stripe.com"
  s.author              = { "Alex MacCaw" => "alex@stripe.com" }
  s.source              = { :git => "https://github.com/stripe/Checkout.git", :tag => "v1.0.0"}
  s.source_files        = 'Checkout/**/*.{h,m}'
  s.public_header_files = 'Checkout/**/*.h'
  s.resources           = 'Checkout/PaymentKit/Resources'
  s.platform            = :ios
  s.requires_arc        = true
end